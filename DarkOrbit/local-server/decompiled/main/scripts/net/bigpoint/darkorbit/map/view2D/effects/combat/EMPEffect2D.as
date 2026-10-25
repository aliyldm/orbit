package net.bigpoint.darkorbit.map.view2D.effects.combat
{
   import com.greensock.TweenLite;
   import com.greensock.TweenMax;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.utils.Dictionary;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.audio.AudioManager;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.map.model.effects.impl.combat.EMPEffect;
   import net.bigpoint.darkorbit.map.view2D.DenseEffectPolicy2D;
   import net.bigpoint.darkorbit.map.view2D.MapView2D;
   import net.bigpoint.darkorbit.map.view2D.effects.AbstractMapObjectEffect2D;
   import net.bigpoint.darkorbit.map.view2D.effects.NativeEffectClipPool2D;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   
   public class EMPEffect2D extends AbstractMapObjectEffect2D
   {
      
      private static var starts:uint;
      
      private static var denseStarts:uint;
      
      private static var flashes:uint;
      
      private static var rings:uint;
      
      private static const SERVER_EMP_RANGE:int = 455;
      
      private static const TYPE_2_RINGCOUNT:* = {};
      
      private static const TYPE_2_CLIPNAME:* = {};
      
      private static const TYPE_2_SHOCKWAVE:* = {};
      
      private static const TYPE_2_SCALE:* = {};
      
      private static const TYPE_ULTIMATE:* = {};
      
      TYPE_2_RINGCOUNT[EMPEffect.TYPE_NORMAL] = 5;
      TYPE_2_RINGCOUNT[EMPEffect.TYPE_ULTIMATE] = 1;
      TYPE_2_RINGCOUNT[EMPEffect.TYPE_EMPEROR] = 4;
      TYPE_2_RINGCOUNT[EMPEffect.TYPE_NUKE] = 7;
      TYPE_2_RINGCOUNT[EMPEffect.TYPE_BURNING_TRAIL] = 5;
      TYPE_2_CLIPNAME[EMPEffect.TYPE_ULTIMATE] = "blitzUltimate";
      TYPE_2_CLIPNAME[EMPEffect.TYPE_ULTIMATE_EPEROR] = "blitzUltimate";
      TYPE_2_SHOCKWAVE[EMPEffect.TYPE_ULTIMATE] = "shockringUltimate";
      TYPE_2_SHOCKWAVE[EMPEffect.TYPE_NUKE] = "shockring0Purple";
      TYPE_2_SHOCKWAVE[EMPEffect.TYPE_BURNING_TRAIL] = "shockring0Orange";
      TYPE_2_SCALE[EMPEffect.TYPE_BURNING_TRAIL] = 250;
      TYPE_2_SCALE[EMPEffect.TYPE_NUKE] = 430;
      TYPE_ULTIMATE[EMPEffect.TYPE_ULTIMATE] = true;
      TYPE_ULTIMATE[EMPEffect.TYPE_ULTIMATE_EPEROR] = true;
      
      private var compact:Boolean;
      
      private var ended:Boolean;
      
      private var owned:Dictionary = new Dictionary();
      
      public function EMPEffect2D(param1:MapView2D, param2:EMPEffect)
      {
         super(param1,param2);
      }
      
      private function acquire(param1:SWFFinisher, param2:String) : MovieClip
      {
         var _loc3_:MovieClip = NativeEffectClipPool2D.acquireSymbol(param1,"shockwaves",param2);
         this.owned[_loc3_] = true;
         return _loc3_;
      }
      
      override public function disposeView(param1:Boolean = false) : void
      {
         var _loc2_:Object = null;
         if(this.ended)
         {
            return;
         }
         this.ended = true;
         TweenMax.killTweensOf(this.showEMPRing);
         TweenMax.killTweensOf(this.fadeOutBolt);
         for(_loc2_ in this.owned)
         {
            this.removeFromParent(_loc2_ as DisplayObject);
         }
         while(numChildren)
         {
            this.removeFromParent(getChildAt(numChildren - 1));
         }
         super.disposeView(param1);
      }
      
      override protected function initEffectVisuals() : void
      {
         if(this.ended)
         {
            return;
         }
         if(!ResourceManager.isLoaded("lensFlash"))
         {
            ResourceManager.loadAndCall("lensFlash",this.initEffectVisuals,arguments);
            return;
         }
         if(!ResourceManager.isLoaded("shockwaves"))
         {
            ResourceManager.loadAndCall("shockwaves",this.initEffectVisuals,arguments);
            return;
         }
         this.start();
      }
      
      override protected function start() : void
      {
         if(this.ended)
         {
            return;
         }
         this.compact = DenseEffectPolicy2D.denseScene;
         ++starts;
         if(this.compact)
         {
            ++denseStarts;
         }
         var _loc1_:SWFFinisher = SWFFinisher(ResourceManager.fileCollection.getFinisher("shockwaves"));
         var _loc2_:Bitmap = ResourceManager.getBitmap("lensFlash","lensFlash");
         if(this.compact)
         {
            _loc2_.alpha = 0.16;
            _loc2_.scaleX = _loc2_.scaleY = 0.5;
         }
         ++flashes;
         _loc2_.x = -_loc2_.width * 0.5;
         _loc2_.y = -_loc2_.height * 0.5;
         addChild(_loc2_);
         TweenLite.to(_loc2_,0.25,{
            "alpha":0,
            "onComplete":this.removeFromParent,
            "onCompleteParams":[_loc2_]
         });
         var _loc3_:Number = 0;
         var _loc4_:Number = Number(Number(TYPE_2_RINGCOUNT[this.empEffect.empType]) || 5);
         if(this.compact)
         {
            _loc4_ = Math.min(2,_loc4_);
         }
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            TweenMax.delayedCall(this.empEffect.empType == EMPEffect.TYPE_EMPEROR ? _loc3_ * 0.3 : _loc3_,this.showEMPRing,[_loc1_,this,_loc5_]);
            _loc3_ += 0.1;
            _loc5_++;
         }
         var _loc6_:MovieClip = this.acquire(_loc1_,TYPE_2_CLIPNAME[this.empEffect.empType] || "blitz");
         MovieClipUtils.playAnimation(_loc6_,15,true);
         _loc6_.scaleX = 0.1;
         _loc6_.scaleY = 0.1;
         addChild(_loc6_);
         if(this.isUltimate)
         {
            TweenLite.to(_loc6_,1.5,{
               "scaleX":1.5,
               "scaleY":1.5,
               "onComplete":this.removeFromParent,
               "onCompleteParams":[_loc6_]
            });
         }
         else if(this.isBurningTrail || this.isNPCNuke)
         {
            TweenLite.to(_loc6_,1.5,{
               "scaleX":1,
               "scaleY":1,
               "onComplete":this.removeFromParent,
               "onCompleteParams":[_loc6_]
            });
         }
         else
         {
            TweenLite.to(_loc6_,1.5,{
               "scaleX":(this.compact ? 1.4 : 3.5),
               "scaleY":(this.compact ? 1.4 : 3.5),
               "onComplete":this.removeFromParent,
               "onCompleteParams":[_loc6_]
            });
         }
         TweenMax.delayedCall(0.75,this.fadeOutBolt,[_loc6_]);
         AudioManager.playSoundEffect(this.empEffect.soundID,false,false,x,y);
      }
      
      private function get isUltimate() : Boolean
      {
         return TYPE_ULTIMATE[this.empEffect.empType];
      }
      
      private function get isNPCNuke() : Boolean
      {
         return this.empEffect.empType == EMPEffect.TYPE_NUKE;
      }
      
      private function get isBurningTrail() : Boolean
      {
         return this.empEffect.empType == EMPEffect.TYPE_BURNING_TRAIL;
      }
      
      private function get isEmperor() : Boolean
      {
         return this.empEffect.empType == EMPEffect.TYPE_EMPEROR || this.empEffect.empType == EMPEffect.TYPE_ULTIMATE_EPEROR;
      }
      
      private function removeFromParent(param1:DisplayObject) : void
      {
         TweenMax.killTweensOf(param1);
         if(param1 is MovieClip && Boolean(this.owned[param1]))
         {
            delete this.owned[param1];
            MovieClipUtils.stopAnimation(param1);
            NativeEffectClipPool2D.release(param1 as MovieClip);
         }
         else
         {
            MovieClipUtils.removeDisplayObject(param1);
         }
      }
      
      private function fadeOutBolt(param1:MovieClip) : void
      {
         if(this.ended)
         {
            return;
         }
         TweenLite.to(param1,0.25,{
            "alpha":0,
            "onComplete":this.disposeView
         });
      }
      
      private function showEMPRing(param1:SWFFinisher, param2:Sprite, param3:int) : void
      {
         var _loc4_:MovieClip = null;
         var _loc6_:Number = NaN;
         if(this.ended)
         {
            return;
         }
         var _loc5_:String = TYPE_2_SHOCKWAVE[this.empEffect.empType] || "shockring0";
         if(this.isEmperor && param3 < 2)
         {
            _loc5_ = "shockring0Red";
         }
         _loc4_ = this.acquire(param1,_loc5_);
         if(this.isNPCNuke)
         {
            _loc6_ = TYPE_2_SCALE[EMPEffect.TYPE_NUKE] / (_loc4_.width / 2);
         }
         else if(this.isBurningTrail)
         {
            _loc6_ = TYPE_2_SCALE[EMPEffect.TYPE_BURNING_TRAIL] / (_loc4_.width / 2);
         }
         else
         {
            _loc6_ = SERVER_EMP_RANGE / (_loc4_.width / 2);
         }
         _loc4_.scaleX = 0.1;
         _loc4_.scaleY = 0.1;
         if(this.isUltimate)
         {
            _loc4_.alpha = 0.7;
         }
         else if(this.isNPCNuke || this.isBurningTrail)
         {
            _loc4_.alpha = 0.5;
         }
         else
         {
            _loc4_.alpha = 0.3;
         }
         ++rings;
         param2.addChild(_loc4_);
         TweenLite.to(_loc4_,1.5,{
            "scaleX":(this.isEmperor ? 9 : _loc6_),
            "scaleY":(this.isEmperor ? 9 : _loc6_),
            "alpha":0,
            "onComplete":this.removeFromParent,
            "onCompleteParams":[_loc4_]
         });
      }
      
      private function get empEffect() : EMPEffect
      {
         return effect as EMPEffect;
      }
   }
}

