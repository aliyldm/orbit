package net.bigpoint.darkorbit.map.view2D.display.decorators
{
   import com.bigpoint.utils.StringPair;
   import net.bigpoint.darkorbit.map.common.IDisposable;
   import net.bigpoint.darkorbit.map.model.traits.UberDisplayTrait;
   import net.bigpoint.darkorbit.map.model.traits.hud.MapObjectInfoTrait;
   import net.bigpoint.darkorbit.map.view2D.display.IMapUberAssetDecorator2D;
   import net.bigpoint.darkorbit.map.view2D.display.uber.UberAsset2D;
   import net.bigpoint.darkorbit.map.view2D.display.uber.UberDisplayObject2D;
   import net.bigpoint.darkorbit.mvc.battleStation.BattleStation;
   
   public class BattleStationDecorator2D implements IMapUberAssetDecorator2D, IDisposable
   {
      
      private static const SHIELD:String = "shield";
      
      private static const HULL:String = "hull";
      
      private static const FACTION:String = "faction";
      
      private var _trait:UberDisplayTrait;
      
      private var _viewOwner:UberAsset2D;
      
      private var _keymap:ReskeyMap;
      
      public function BattleStationDecorator2D()
      {
         super();
      }
      
      public function decorateUberAsset(param1:UberDisplayTrait, param2:UberAsset2D, param3:Object) : void
      {
         this._viewOwner = param2;
         this._trait = param1;
         this._keymap = new ReskeyMap(param2.descriptor);
         this.battleStation.changed.add(this.handleChanged);
         this.handleChanged();
      }
      
      public function disposeView(param1:Boolean = false) : void
      {
         this.battleStation.changed.remove(this.handleChanged);
         this._trait = null;
         this._viewOwner = null;
         this._keymap = null;
      }
      
      private function handleChanged() : void
      {
         this.reload(HULL,this.battleStation.hullExpansion / 5 - 1);
         this.reload(SHIELD,this.battleStation.deflectorShildExpansion / 5 - 1);
         this.reload(FACTION,(this.battleStation.getFirstTrait(MapObjectInfoTrait) as MapObjectInfoTrait).factionID.value);
      }
      
      private function reload(param1:String, param2:int) : void
      {
         var _loc3_:StringPair = this._keymap.getResKey(param1,param2);
         this.getViewById(param1).load(_loc3_.right,_loc3_.left);
      }
      
      private function get battleStation() : BattleStation
      {
         return this._trait.owner as BattleStation;
      }
      
      private function getViewById(param1:String) : UberDisplayObject2D
      {
         return this._viewOwner.getViewElement(param1) as UberDisplayObject2D;
      }
   }
}

import com.bigpoint.utils.StringPair;

class ReskeyMap
{
   
   private var _descriptor:XML;
   
   public function ReskeyMap(param1:XML)
   {
      super();
      this._descriptor = param1;
   }
   
   public function getResKey(param1:String, param2:int) : StringPair
   {
      var _loc4_:XML = null;
      var _loc3_:XMLList = this._descriptor.child(param1);
      for each(_loc4_ in _loc3_)
      {
         if(int(_loc4_.attribute("id")) == param2)
         {
            return new StringPair(_loc4_.attribute("resKey"),_loc4_.attribute("srcKey"));
         }
      }
      return new StringPair("","");
   }
}
