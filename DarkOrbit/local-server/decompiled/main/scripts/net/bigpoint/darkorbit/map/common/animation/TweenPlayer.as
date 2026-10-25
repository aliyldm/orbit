package net.bigpoint.darkorbit.map.common.animation
{
   import com.greensock.TimelineMax;
   import com.greensock.TweenMax;
   import com.greensock.core.TweenCore;
   import com.greensock.events.TweenEvent;
   import com.greensock.plugins.BezierThroughPlugin;
   import com.greensock.plugins.FrameBackwardPlugin;
   import com.greensock.plugins.FrameForwardPlugin;
   import com.greensock.plugins.FrameLabelPlugin;
   import com.greensock.plugins.FramePlugin;
   import com.greensock.plugins.TweenPlugin;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class TweenPlayer
   {
      
      TweenPlugin.activate([FramePlugin,FrameLabelPlugin,FrameBackwardPlugin,FrameForwardPlugin,BezierThroughPlugin]);
      
      public const completed:ISignal = new Signal();
      
      private var _timeline:TimelineMax;
      
      private var _vo:AnimationData;
      
      private var _targetProvider:Object;
      
      public function TweenPlayer(param1:AnimationData, param2:Object)
      {
         super();
         this._vo = param1;
         this._targetProvider = param2;
      }
      
      public function start() : void
      {
         if(!this._timeline)
         {
            this.initTimeLine();
         }
         this._timeline.play();
      }
      
      public function resume() : void
      {
         if(this._timeline)
         {
            this._timeline.resume();
         }
      }
      
      public function pause() : void
      {
         if(this._timeline)
         {
            this._timeline.pause();
         }
      }
      
      public function stop() : void
      {
         if(this._timeline)
         {
            this._timeline.stop();
         }
      }
      
      public function dispose() : void
      {
         if(this._timeline)
         {
            this._timeline.stop();
            this._timeline.kill();
            this._timeline = null;
         }
      }
      
      public function reset() : void
      {
         if(this._timeline)
         {
            this._timeline.restart();
            this._timeline.stop();
            this._timeline.kill();
            this._timeline = null;
         }
      }
      
      private function initTimeLine() : void
      {
         this._timeline = this.animationToTimeline(this._vo);
         this._timeline.addEventListener(TweenEvent.COMPLETE,this.handleRootTimelineComplete);
      }
      
      private function animationToTimeline(param1:AnimationData) : TimelineMax
      {
         var _loc5_:Object = null;
         var _loc6_:TweenCore = null;
         var _loc7_:TweenData = null;
         var _loc8_:Object = null;
         var _loc2_:TimelineMax = new TimelineMax({
            "yoyo":param1.yoyo,
            "repeat":param1.repeat
         });
         var _loc3_:int = int(param1.children.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = param1.children[_loc4_];
            if(_loc5_ is AnimationData)
            {
               _loc6_ = this.animationToTimeline(_loc5_ as AnimationData);
            }
            else
            {
               _loc7_ = _loc5_ as TweenData;
               _loc8_ = this._targetProvider is Function ? (this._targetProvider as Function)(_loc7_.targetId) : this._targetProvider;
               if(_loc8_)
               {
                  _loc6_ = new TweenMax(_loc8_,_loc7_.time,_loc7_.props);
               }
            }
            if(_loc6_)
            {
               if(param1.parallel)
               {
                  _loc2_.insert(_loc6_);
               }
               else
               {
                  _loc2_.append(_loc6_);
               }
            }
            _loc4_++;
         }
         _loc2_.currentTime = param1.currentTime;
         return _loc2_;
      }
      
      private function handleRootTimelineComplete(param1:TweenEvent) : void
      {
         this.completed.dispatch();
      }
   }
}

