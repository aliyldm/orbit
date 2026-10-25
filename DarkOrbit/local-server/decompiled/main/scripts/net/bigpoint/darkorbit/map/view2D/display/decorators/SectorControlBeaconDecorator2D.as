package net.bigpoint.darkorbit.map.view2D.display.decorators
{
   import com.greensock.TweenMax;
   import com.greensock.TweenNano;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.audio.AudioManager;
   import net.bigpoint.darkorbit.map.model.traits.UberDisplayTrait;
   import net.bigpoint.darkorbit.map.view2D.display.IMapUberAssetDecorator2D;
   import net.bigpoint.darkorbit.map.view2D.display.uber.UberAsset2D;
   import net.bigpoint.darkorbit.map.view2D.display.uber.UberDisplayObject2D;
   import net.bigpoint.darkorbit.mvc.sectorControl.map.ControlPoint;
   
   public class SectorControlBeaconDecorator2D extends Sprite implements IMapUberAssetDecorator2D
   {
      
      private var _controlPoint:ControlPoint;
      
      private var _viewOwner:UberAsset2D;
      
      private var _displayTrait:UberDisplayTrait;
      
      public function SectorControlBeaconDecorator2D()
      {
         super();
      }
      
      public function decorateUberAsset(param1:UberDisplayTrait, param2:UberAsset2D, param3:Object) : void
      {
         this._controlPoint = param1.owner as ControlPoint;
         this._displayTrait = param1;
         this._viewOwner = param2;
         this._controlPoint.captureProgress.changed.add(this.updateView);
         this._controlPoint.progressOwner.changed.add(this.updateView);
         this._controlPoint.captureProgress.changed.add(this.checkCaptureSound);
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
      
      private function checkToStartFlickering() : void
      {
         if(this._controlPoint.captureProgress.value == this._controlPoint.captureThreshold.value)
         {
            this.setProgress(1,true);
            TweenNano.killTweensOf(this.flicker);
            TweenNano.killTweensOf(this.checkToStartFlickering);
            TweenNano.delayedCall(1 + Math.random() * 2,this.flicker);
         }
      }
      
      private function flicker() : void
      {
         if(this._controlPoint.captureProgress.value == this._controlPoint.captureThreshold.value)
         {
            this.setProgress(1,true);
            TweenNano.delayedCall(0.2,this.checkToStartFlickering);
         }
      }
      
      private function updateView() : void
      {
         var _loc1_:String = InGameCatalog.getInstance().factions_names[this._controlPoint.progressOwner.value] as String;
         this._displayTrait.state.value = _loc1_ || "Neutral";
         this.checkToStartFlickering();
         this.setProgress(this._controlPoint.capturePercentage,false);
      }
      
      private function setProgress(param1:Number, param2:Boolean) : void
      {
         var _loc4_:UberDisplayObject2D = null;
         var _loc3_:Vector.<UberDisplayObject2D> = this._viewOwner.getAllDisplayObjects();
         for each(_loc4_ in _loc3_)
         {
            TweenMax.to(_loc4_.asset,param2 ? 0 : 1,{"frame":Math.round(1 + param1 * (MovieClip(_loc4_.asset).totalFrames - 2))});
         }
      }
   }
}

