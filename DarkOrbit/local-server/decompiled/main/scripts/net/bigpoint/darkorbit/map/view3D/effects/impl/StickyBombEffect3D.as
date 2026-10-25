package net.bigpoint.darkorbit.map.view3D.effects.impl
{
   import away3d.containers.ObjectContainer3D;
   import com.greensock.TweenLite;
   import com.greensock.easing.Quad;
   import flash.geom.Vector3D;
   import flash.media.SoundChannel;
   import flash.utils.Timer;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.audio.AudioManager;
   import net.bigpoint.darkorbit.map.common.IDisposable;
   import net.bigpoint.darkorbit.map.model.effects.impl.AbstractStickyBombEffect;
   import net.bigpoint.darkorbit.map.model.traits.UberDisplayTrait;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   import net.bigpoint.darkorbit.map.view3D.display3D.World3D;
   import net.bigpoint.darkorbit.map.view3D.display3D.uber.UberAsset3D;
   import net.bigpoint.darkorbit.map.view3D.display3D.uber.UberMesh3D;
   import net.bigpoint.darkorbit.mvc.common.model.assets.UberAssetsLib;
   
   public class StickyBombEffect3D implements IDisposable
   {
      
      private static var beepSoundChannel:SoundChannel = null;
      
      private static const DATA:Object = {};
      
      DATA[AbstractStickyBombEffect.NORMAL] = {
         "asset":"stickybomb",
         "warmUpDuration":9
      };
      DATA[AbstractStickyBombEffect.EMPEROR] = {
         "asset":"stickybomb-emperor",
         "warmUpDuration":7
      };
      DATA[AbstractStickyBombEffect.EXPLODING_CHARGING_BLOB] = {
         "asset":"explosive-charging-blob",
         "warmUpDuration":6
      };
      
      private var _uberAsset:UberAsset3D;
      
      private var _effect:AbstractStickyBombEffect;
      
      private var _timer:Timer;
      
      private var _secondsLeft:int = -1;
      
      private var _fps:int = 5;
      
      private var _lightVisible:Boolean = false;
      
      private var _tagetView:ObjectContainer3D;
      
      public function StickyBombEffect3D(param1:MapView3D, param2:AbstractStickyBombEffect)
      {
         super();
         this._effect = param2;
         this._tagetView = param1.mainContainer.getViewByTrait(param2.source.getFirstTrait(UberDisplayTrait));
         if(param2.source != null)
         {
            this.stage1();
         }
         else
         {
            this.stage2();
         }
      }
      
      public function disposeView(param1:Boolean = false) : void
      {
         this.cleanupStage1();
         this.cleanupStage2();
      }
      
      private function stage1() : void
      {
         var _loc1_:String = DATA[this._effect.stickyBombType]["asset"];
         var _loc2_:XML = UberAssetsLib.instance.getDescriptor(_loc1_,UberAssetsLib.LIB_DEFAULT);
         this._uberAsset = new UberAsset3D(_loc2_.display3D[0]);
         this.glow = 0;
         this._uberAsset.ready.add(this.assetReadyForStage1);
      }
      
      private function stage2() : void
      {
         if(this._uberAsset)
         {
            World3D.instance.mapView.gameWorld.addChild(this._uberAsset);
            this._uberAsset.playAnimation("open");
            this._secondsLeft = DATA[this._effect.stickyBombType]["warmUpDuration"];
            this._fps = 5;
            this.proceed();
            TweenLite.delayedCall(1,this.updateSpeed);
         }
         else
         {
            this.disposeView();
         }
      }
      
      private function assetReadyForStage1() : void
      {
         if(this._effect.bombSource == null)
         {
            this.disposeView();
         }
         else
         {
            World3D.instance.mapView.gameWorld.addChild(this._uberAsset);
            this._uberAsset.moveTo(this._effect.bombSource.x3D,this._effect.bombSource.y3D,this._effect.bombSource.z3D);
            TweenLite.to(this._uberAsset,0.5,{
               "dynamicProps":{
                  "x":this.getX,
                  "z":this.getZ
               },
               "onUpdate":this.update,
               "onComplete":this.handleStage1Finished
            });
            TweenLite.to(this._uberAsset.uberMeshes[0],0.25,{
               "delay":0.25,
               "rotationZ":0,
               "ease":Quad.easeInOut
            });
         }
      }
      
      private function update() : void
      {
         this._uberAsset.rotationY = this.getRotation();
      }
      
      private function proceed() : void
      {
         if(this._uberAsset)
         {
            this._tagetView.addChild(this._uberAsset);
            this._uberAsset.position = new Vector3D();
         }
         this._fps = 1;
         this.loopFunc();
      }
      
      private function loopFunc() : void
      {
         this._lightVisible = !this._lightVisible;
         if(this._lightVisible)
         {
            AudioManager.playSoundEffect(InGameCatalog.SOUND_ID_STICKYBOMB_BEEP);
            this.glow = 2;
         }
         else
         {
            this.glow = 0;
         }
         if(this._secondsLeft <= 1)
         {
            this.glow = 2;
            this._lightVisible = true;
            if(beepSoundChannel)
            {
               AudioManager.removeLoop(beepSoundChannel);
            }
            beepSoundChannel = AudioManager.playSoundEffect(InGameCatalog.SOUND_ID_STICKYBOMB_BEEP,true);
            return;
         }
         TweenLite.delayedCall(1 / this._fps,this.loopFunc);
      }
      
      private function set glow(param1:Number) : void
      {
         var _loc2_:UberMesh3D = null;
         for each(_loc2_ in this._uberAsset.uberMeshes)
         {
            _loc2_.glow = param1;
         }
      }
      
      private function updateSpeed() : void
      {
         if(this._secondsLeft-- > 0)
         {
            ++this._fps;
            TweenLite.delayedCall(1,this.updateSpeed);
         }
      }
      
      private function getX() : int
      {
         return this._effect.bombTarget.x3D;
      }
      
      private function getZ() : int
      {
         return this._effect.bombTarget.z3D;
      }
      
      private function getRotation() : Number
      {
         var _loc1_:Number = Math.atan2(this._uberAsset.x - this._effect.bombTarget.x3D,this._uberAsset.z - this._effect.bombTarget.z3D) * 180 / Math.PI;
         return _loc1_ - 90;
      }
      
      private function cleanupStage1() : void
      {
         TweenLite.killTweensOf(this._uberAsset);
      }
      
      private function cleanupStage2() : void
      {
         if(beepSoundChannel)
         {
            AudioManager.removeLoop(beepSoundChannel);
         }
         if(this._uberAsset)
         {
            if(this._uberAsset.parent)
            {
               this._uberAsset.parent.removeChild(this._uberAsset);
            }
            this._uberAsset = null;
         }
         TweenLite.killTweensOf(this.updateSpeed);
         TweenLite.killTweensOf(this.proceed);
         TweenLite.killTweensOf(this.loopFunc);
      }
      
      private function handleStage1Finished() : void
      {
         this.cleanupStage1();
         this.stage2();
      }
   }
}

