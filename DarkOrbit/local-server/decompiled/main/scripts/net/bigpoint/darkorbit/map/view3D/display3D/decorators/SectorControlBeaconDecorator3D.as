package net.bigpoint.darkorbit.map.view3D.display3D.decorators
{
   import com.greensock.TweenLite;
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.audio.AudioManager;
   import net.bigpoint.darkorbit.com.module.FactionModule;
   import net.bigpoint.darkorbit.map.model.traits.UberDisplayTrait;
   import net.bigpoint.darkorbit.map.view3D.display3D.prefab.PrefabView3D;
   import net.bigpoint.darkorbit.map.view3D.display3D.uber.UberAsset3D;
   import net.bigpoint.darkorbit.map.view3D.display3D.uber.UberMesh3D;
   import net.bigpoint.darkorbit.mvc.sectorControl.map.ControlPoint;
   
   public class SectorControlBeaconDecorator3D extends Sprite implements IMapUberAssetDecorator3D
   {
      
      private static const COLORS:Object = {};
      
      COLORS[0] = 0;
      COLORS[FactionModule.FACTION_MMO] = 16188934;
      COLORS[FactionModule.FACTION_EIC] = 494584;
      COLORS[FactionModule.FACTION_VRU] = 6156289;
      
      private var _controlPoint:ControlPoint;
      
      private var _viewOwner:UberAsset3D;
      
      private var _displayTrait:UberDisplayTrait;
      
      private var _zeroProgress:Boolean = true;
      
      private var _beaconView:PrefabView3D;
      
      public function SectorControlBeaconDecorator3D()
      {
         super();
      }
      
      public function initialize(param1:UberDisplayTrait, param2:UberAsset3D, param3:Object) : void
      {
         this._controlPoint = param1.owner as ControlPoint;
         this._displayTrait = param1;
         this._viewOwner = param2;
      }
      
      public function decorate() : void
      {
         if(this._controlPoint)
         {
            this._controlPoint.captureProgress.changed.add(this.updateView);
            this._controlPoint.progressOwner.changed.add(this.updateView);
            this._controlPoint.captureProgress.changed.add(this.checkCaptureSound);
         }
         this._beaconView = UberMesh3D(this._viewOwner.getViewElement("beacon")).mesh;
         this._beaconView.shaderParams.progress = 1;
         this.updateView();
      }
      
      private function checkCaptureSound() : void
      {
         if(!this._controlPoint.enabled.value)
         {
            return;
         }
         var _loc1_:Number = this._controlPoint.capturePercentage;
         if(_loc1_ == 0)
         {
            AudioManager.playSoundEffect(InGameCatalog.SOUND_ID_SECTOR_NEUTRALIZED);
         }
         else if(_loc1_ == 1)
         {
            AudioManager.playSoundEffect(InGameCatalog.SOUND_ID_SECTOR_CAPTURED);
         }
      }
      
      private function updateView() : void
      {
         var _loc1_:String = InGameCatalog.getInstance().factions_names[this._controlPoint.progressOwner.value] as String;
         this._displayTrait.state.value = _loc1_ || "Neutral";
         this._beaconView.shaderParams.progressColor = COLORS[this._controlPoint.progressOwner.value];
         var _loc2_:Boolean = this._controlPoint.captureProgress.value == this._controlPoint.captureThreshold.value;
         this._viewOwner.getViewElement("logo").visible = _loc2_;
         if(_loc2_)
         {
            this.setProgress(1,true);
         }
         else
         {
            this.setProgress(this._controlPoint.capturePercentage,false);
         }
      }
      
      private function setProgress(param1:Number, param2:Boolean) : void
      {
         if(param2)
         {
            this._beaconView.shaderParams.progress = param1;
         }
         else
         {
            TweenLite.to(this._beaconView.shaderParams,0.2,{"progress":param1});
         }
         var _loc3_:Boolean = param1 == 0;
         if(this._zeroProgress != _loc3_)
         {
            this._zeroProgress = _loc3_;
            if(this._zeroProgress)
            {
               this._viewOwner.playAnimation("close");
            }
            else
            {
               this._viewOwner.playAnimation("open");
            }
         }
      }
   }
}

