package net.bigpoint.darkorbit.map.view3D.display3D.decorators
{
   import net.bigpoint.darkorbit.map.common.IDisposable;
   import net.bigpoint.darkorbit.map.model.traits.UberDisplayTrait;
   import net.bigpoint.darkorbit.map.view3D.display3D.uber.UberAsset3D;
   import net.bigpoint.darkorbit.mvc.battleStation.BattleStation;
   
   public class BattleStationDecorator3D implements IMapUberAssetDecorator3D, IDisposable
   {
      
      private var _trait:UberDisplayTrait;
      
      private var _viewOwner:UberAsset3D;
      
      public function BattleStationDecorator3D()
      {
         super();
      }
      
      public function initialize(param1:UberDisplayTrait, param2:UberAsset3D, param3:Object) : void
      {
         this._viewOwner = param2;
         this._trait = param1;
      }
      
      public function decorate() : void
      {
         this.battleStation.changed.add(this.updateVisuals);
         this.updateVisuals();
      }
      
      public function disposeView(param1:Boolean = false) : void
      {
         this.battleStation.changed.remove(this.updateVisuals);
         this._trait = null;
         this._viewOwner = null;
      }
      
      private function updateVisuals() : void
      {
         this._viewOwner.getViewElement("mesh.content.hull_left").visible = this.battleStation.hullExpansion >= 5;
         this._viewOwner.getViewElement("mesh.content.hull_right").visible = this.battleStation.hullExpansion >= 10;
         this._viewOwner.getViewElement("mesh.content.deflector_level_1").visible = this.battleStation.deflectorShildExpansion >= 0;
         this._viewOwner.getViewElement("mesh.content.deflector_level_2").visible = this.battleStation.deflectorShildExpansion >= 5;
         this._viewOwner.getViewElement("mesh.content.deflector_level_3").visible = this.battleStation.deflectorShildExpansion >= 10;
      }
      
      private function get battleStation() : BattleStation
      {
         return this._trait.owner as BattleStation;
      }
   }
}

