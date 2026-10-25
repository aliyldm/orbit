package net.bigpoint.darkorbit.map.view2D.display.ship.decorators
{
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.map.common.IDisposable;
   import net.bigpoint.darkorbit.map.model.ship.PodCarrierTrait;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.map.view2D.display.ship.Ship2D;
   import net.bigpoint.darkorbit.map.view2D.display.ship.ShipClip;
   import net.bigpoint.darkorbit.settings.Settings;
   
   public class Pod2D extends ShipClip implements IDisposable
   {
      
      private var _viewOwner:Ship2D;
      
      public function Pod2D(param1:PodCarrierTrait, param2:Ship2D)
      {
         super();
         this._viewOwner = param2;
         this.loadPod();
         this._viewOwner.base.loaded.add(this.loadPod);
      }
      
      private function loadPod() : void
      {
         var _loc1_:String = null;
         if(this.ship.shipPattern.podType != InGameCatalog.POD_TYPE_NONE)
         {
            rotationSource = this.ship.rotation;
            if(Settings.qualityShip.value > Settings.QUALITY_LOW)
            {
               _loc1_ = this.ship.shipPattern.getPodPattern(this.ship.info.factionID.value).srcKey;
               load(_loc1_,"mc");
            }
            else
            {
               load("replacementShips","ship49_pod");
            }
         }
         else
         {
            clip = null;
         }
      }
      
      private function get ship() : Ship
      {
         return this._viewOwner.ship;
      }
      
      override public function disposeView(param1:Boolean = false) : void
      {
         this._viewOwner.base.loaded.remove(this.loadPod);
         super.disposeView(param1);
      }
   }
}

