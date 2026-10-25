package net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.model.vo.slotBar
{
   import com.bigpoint.utils.PointLite;
   import net.bigpoint.darkorbit.mvc.gui.common.abstract.model.vo.AbstractMenuBarVO;
   import net.bigpoint.darkorbit.net.ServerCommands;
   
   public class SlotBarVO extends AbstractMenuBarVO
   {
      
      private var _slotBars:Vector.<SlotVO>;
      
      private var _stickOffset:PointLite;
      
      private var _isVisible:Boolean = true;
      
      public function SlotBarVO(param1:String, param2:String, param3:Vector.<PointLite>, param4:Vector.<SlotVO>, param5:Boolean = true)
      {
         super(param1,param2,param3[0]);
         this._isVisible = param5;
         this._slotBars = param4;
         this._stickOffset = param3.length > 1 ? param3[1] : new PointLite();
      }
      
      override public function get positionCords() : String
      {
         return super.positionCords + ServerCommands.SETTING_KEY_SET_SEPERATOR + this._stickOffset.x + ServerCommands.SETTING_KEY_SEPERATOR + this._stickOffset.y;
      }
      
      public function get slotBars() : Vector.<SlotVO>
      {
         return this._slotBars;
      }
      
      public function get stickOffset() : PointLite
      {
         return this._stickOffset;
      }
      
      public function set stickOffset(param1:PointLite) : void
      {
         this._stickOffset = param1;
      }
      
      public function get isVisible() : Boolean
      {
         return this._isVisible;
      }
      
      public function set isVisible(param1:Boolean) : void
      {
         this._isVisible = param1;
      }
   }
}

