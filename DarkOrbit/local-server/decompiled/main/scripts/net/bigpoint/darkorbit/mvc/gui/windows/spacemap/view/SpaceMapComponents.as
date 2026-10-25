package net.bigpoint.darkorbit.mvc.gui.windows.spacemap.view
{
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Container;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   
   public class SpaceMapComponents
   {
      
      private var _view:Sprite;
      
      public function SpaceMapComponents(param1:Sprite)
      {
         super();
         this._view = param1;
      }
      
      public function getMapBg() : Coreponent
      {
         return FuiComponentSelectorUtil.selectComponent("contentContainer.mapsBG",this._view) as Coreponent;
      }
      
      public function getControlsBG() : Coreponent
      {
         return FuiComponentSelectorUtil.selectComponent("contentContainer.cpuJumpControls.controlsBG",this._view) as Coreponent;
      }
      
      public function get content() : Container
      {
         return FuiComponentSelectorUtil.selectComponent("contentContainer",this._view) as Container;
      }
      
      public function get blinkerSmall() : Coreponent
      {
         return FuiComponentSelectorUtil.selectComponent("contentContainer.blinkerSmall",this._view) as Coreponent;
      }
      
      public function get blinkerBig() : Coreponent
      {
         return FuiComponentSelectorUtil.selectComponent("contentContainer.blinkerBig",this._view) as Coreponent;
      }
      
      public function get currentMapIdLabel() : Label
      {
         return FuiComponentSelectorUtil.selectComponent("contentContainer.cpuJumpControls.currentMapIdLabel",this._view) as Label;
      }
      
      public function get selectedMapIdLabel() : Label
      {
         return FuiComponentSelectorUtil.selectComponent("contentContainer.cpuJumpControls.selectedMapIdLabel",this._view) as Label;
      }
      
      public function get maps() : Coreponent
      {
         return FuiComponentSelectorUtil.selectComponent("contentContainer.maps",this._view) as Coreponent;
      }
      
      public function get jumpPriceInfo() : Label
      {
         return FuiComponentSelectorUtil.selectComponent("contentContainer.cpuJumpControls.jumpPriceBackground.jumpPriceInfo",this._view) as Label;
      }
      
      public function get jumpBtn() : Button
      {
         return FuiComponentSelectorUtil.selectComponent("contentContainer.cpuJumpControls.btnJumpConformation",this._view) as Button;
      }
      
      public function get jumpLockedInfo() : Label
      {
         return FuiComponentSelectorUtil.selectComponent("contentContainer.cpuJumpControls.jumpLockedInfo",this._view) as Label;
      }
      
      public function get jumpVoucherInfo() : Label
      {
         return FuiComponentSelectorUtil.selectComponent("contentContainer.cpuJumpControls.jumpVoucherInfo",this._view) as Label;
      }
      
      public function get jumpVoucherAmount() : Label
      {
         return FuiComponentSelectorUtil.selectComponent("contentContainer.cpuJumpControls.jumpVoucherAmount",this._view) as Label;
      }
      
      public function get cpuJumpControls() : Container
      {
         return FuiComponentSelectorUtil.selectComponent("contentContainer.cpuJumpControls",this._view) as Container;
      }
      
      public function getMapById(param1:int) : Button
      {
         return FuiComponentSelectorUtil.selectComponent("contentContainer.maps.map_" + param1,this._view) as Button;
      }
      
      public function getMapIconsByName(param1:String) : Coreponent
      {
         return FuiComponentSelectorUtil.selectComponent("contentContainer.mapIcons." + param1,this._view) as Coreponent;
      }
      
      public function getAllMaps() : Vector.<Button>
      {
         var _loc1_:Container = null;
         _loc1_ = FuiComponentSelectorUtil.selectComponent("contentContainer.maps",this._view) as Container;
         var _loc2_:uint = uint(_loc1_.numChildren);
         var _loc3_:Vector.<Button> = new Vector.<Button>(_loc2_,true);
         var _loc4_:uint = 0;
         while(_loc4_ < _loc2_)
         {
            _loc3_[_loc4_] = Button(_loc1_.getChildAt(_loc4_));
            _loc4_++;
         }
         return _loc3_;
      }
      
      public function getMapId(param1:Button) : int
      {
         var _loc2_:Array = param1.name.split("_");
         return parseInt(_loc2_[1]);
      }
   }
}

