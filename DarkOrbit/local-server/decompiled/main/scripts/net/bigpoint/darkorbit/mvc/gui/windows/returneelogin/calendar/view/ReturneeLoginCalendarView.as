package net.bigpoint.darkorbit.mvc.gui.windows.returneelogin.calendar.view
{
   import com.bigpoint.utils.PointLite;
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.core.InvalidationType;
   import net.bigpoint.darkorbit.fui.components.core.data.VectorCollection;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemList;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.view.components.ITabItem;
   import net.bigpoint.darkorbit.mvc.gui.windows.miniClientReward.model.MiniClientRewardVO;
   
   public class ReturneeLoginCalendarView implements ITabItem
   {
      
      private var _cache:FuiComponentSelectorCache;
      
      private var _view:Coreponent;
      
      private var _defaultViewSize:PointLite;
      
      private var _heightIncrement:int;
      
      public function ReturneeLoginCalendarView(param1:Sprite)
      {
         super();
         this._cache = new FuiComponentSelectorCache(param1);
         this._view = this._cache.selectComponent("calendar") as Coreponent;
         this.calendarList.itemDataAssigner = ReturneeLoginCalendarListItemAssigner;
         this._defaultViewSize = new PointLite(this._view.width,this._view.height);
      }
      
      public function get title() : String
      {
         return "returnee_login_tab_daily_login";
      }
      
      public function get view() : Coreponent
      {
         return this._view;
      }
      
      public function set visible(param1:Boolean) : void
      {
         this._view.visible = param1;
      }
      
      public function get visible() : Boolean
      {
         return this._view.visible;
      }
      
      public function set active(param1:Boolean) : void
      {
      }
      
      public function get active() : Boolean
      {
         return true;
      }
      
      private function get calendarList() : ItemList
      {
         return this._cache.selectComponent("calendar.calendar_list") as ItemList;
      }
      
      public function set calendarGrid(param1:Vector.<MiniClientRewardVO>) : void
      {
         this.calendarList.list = new VectorCollection(param1);
         if(param1.length > 0)
         {
            this.setCalendarListAlignment();
         }
      }
      
      private function setCalendarListAlignment() : void
      {
         if(this._heightIncrement > 0)
         {
            return;
         }
         var _loc1_:int = int(this.calendarList.list.length);
         var _loc2_:int = Math.ceil(_loc1_ / 7);
         _loc2_ += _loc1_ % 7 == 0 ? 1 : 0;
         var _loc3_:int = _loc1_ > 7 ? 7 : 6;
         if(_loc1_ > 7)
         {
            this._heightIncrement = 140 * (_loc2_ - 2);
            this._view.height = this._defaultViewSize.y + this._heightIncrement;
         }
         var _loc4_:int = 10;
         this.calendarList.itemGap = _loc4_;
         this.calendarList.width = 70 * _loc3_ + (_loc4_ * _loc3_ - 1);
         this.calendarList.height = 130 * _loc2_;
         this.calendarList.invalidate(InvalidationType.LAYOUT);
         this.calendarList.marginLeft = _loc3_ == 6 ? 55 : 10;
         this.calendarList.invalidate(InvalidationType.POSITION);
      }
      
      public function get countdownLabel() : Label
      {
         return this._cache.selectComponent("calendar.bottom.countdown_label") as Label;
      }
      
      public function get countdownTimer() : Label
      {
         return this._cache.selectComponent("calendar.bottom.countdown_timer") as Label;
      }
      
      public function get claimBtn() : Button
      {
         return this._cache.selectComponent("calendar.bottom.claim_btn") as Button;
      }
   }
}

