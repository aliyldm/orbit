package net.bigpoint.darkorbit.map.common.animation
{
   import flash.utils.setTimeout;
   import net.bigpoint.darkorbit.map.common.IDisposable;
   import net.bigpoint.darkorbit.map.common.IUpdatable;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class UberAnimationBase implements IUpdatable, IDisposable
   {
      
      public const completed:ISignal = new Signal();
      
      private var _updatables:Vector.<IUpdatable> = new Vector.<IUpdatable>();
      
      private var _xml:XML;
      
      private var _tween:TweenPlayer;
      
      private var _targetProvider:Function;
      
      private var _autoPlay:Boolean;
      
      private var _id:String;
      
      public function UberAnimationBase(param1:String, param2:XML, param3:Function)
      {
         var _loc4_:XML = null;
         super();
         this._id = param1;
         this._xml = param2;
         this._targetProvider = param3;
         this._autoPlay = String(param2.@autoPlay) == "true";
         if(this._xml.tween.length() > 0 || this._xml.animation.length() > 0)
         {
            this._tween = new TweenPlayer(AnimationData.parse(this._xml),this._targetProvider);
            if(String(this._xml.@dispatchCompleteEvent) !== "false")
            {
               this._tween.completed.add(this.handleTweenCompleted);
            }
         }
         for each(_loc4_ in this._xml.append)
         {
            this._updatables.push(new AppendAnim(param3(String(_loc4_.@target)),parseProps(_loc4_)));
         }
      }
      
      public static function parseProps(param1:XML) : Object
      {
         var _loc4_:String = null;
         var _loc5_:Object = null;
         var _loc6_:XML = null;
         var _loc2_:Object = {};
         var _loc3_:XMLList = param1.attributes();
         for each(_loc6_ in _loc3_)
         {
            _loc4_ = _loc6_.name();
            _loc5_ = AnimationData.parseVariable(_loc6_.toString());
            if(!isNaN(Number(_loc5_)))
            {
               if(_loc4_ == "scale")
               {
                  _loc2_.scaleX = _loc2_.scaleY = _loc2_.scaleZ = _loc5_;
               }
               else
               {
                  _loc2_[_loc4_] = _loc5_;
               }
            }
         }
         return _loc2_;
      }
      
      public function get id() : String
      {
         return this._id;
      }
      
      public function play() : void
      {
         this.setInitialState();
         if(this._tween)
         {
            this._tween.reset();
            this._tween.start();
         }
      }
      
      public function stop() : void
      {
         if(this._tween)
         {
            this._tween.dispose();
         }
      }
      
      public function updateObj(param1:Number) : void
      {
         var _loc2_:IUpdatable = null;
         for each(_loc2_ in this._updatables)
         {
            _loc2_.updateObj(param1);
         }
      }
      
      private function setInitialState() : void
      {
         var _loc1_:Object = null;
         var _loc2_:Object = null;
         var _loc3_:XML = null;
         var _loc4_:String = null;
         for each(_loc3_ in this._xml.set)
         {
            _loc1_ = this._targetProvider(String(_loc3_.@target));
            if(_loc1_ != null)
            {
               _loc2_ = parseProps(_loc3_);
               for(_loc4_ in _loc2_)
               {
                  _loc1_[_loc4_] = Number(_loc2_[_loc4_]);
               }
            }
         }
      }
      
      protected function handleTweenCompleted() : void
      {
         setTimeout(this.completed.dispatch,1);
      }
      
      public function get autoPlay() : Boolean
      {
         return this._autoPlay;
      }
      
      public function addUpdatable(param1:IUpdatable) : void
      {
         this._updatables.push(param1);
      }
      
      public function removeUpdatable(param1:IUpdatable) : void
      {
         var _loc2_:int = this._updatables.indexOf(param1);
         if(_loc2_ != -1)
         {
            this._updatables.splice(_loc2_,1);
         }
      }
      
      public function disposeView(param1:Boolean = false) : void
      {
         this.stop();
         if(this._tween)
         {
            this._tween.completed.remove(this.handleTweenCompleted);
            this._tween = null;
         }
      }
   }
}

