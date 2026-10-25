package net.bigpoint.darkorbit.mvc.gui.windows.spacemap.view.ui.meta
{
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.mvc.gui.windows.spacemap.view.SpaceMapComponents;
   
   public class SpaceMapData
   {
      
      private var _mapData:Object;
      
      public function SpaceMapData(param1:SpaceMapComponents)
      {
         var _loc3_:Button = null;
         var _loc4_:int = 0;
         super();
         this._mapData = new Object();
         var _loc2_:Vector.<Button> = param1.getAllMaps();
         var _loc5_:int = int(_loc2_.length);
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            _loc3_ = _loc2_[_loc6_];
            this._mapData[_loc3_.name] = new SpaceMapDataItem();
            _loc4_ = param1.getMapId(_loc3_);
            this._mapData[_loc3_.name].mapId = _loc4_;
            _loc6_++;
         }
      }
      
      public function getMapDataItem(param1:String) : SpaceMapDataItem
      {
         return this._mapData[param1];
      }
   }
}

