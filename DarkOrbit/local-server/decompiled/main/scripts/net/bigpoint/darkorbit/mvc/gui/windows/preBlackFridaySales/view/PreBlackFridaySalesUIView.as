package net.bigpoint.darkorbit.mvc.gui.windows.preBlackFridaySales.view
{
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   
   public class PreBlackFridaySalesUIView
   {
      
      private var _uiContainer:Sprite;
      
      private var _fuiCache:FuiComponentSelectorCache;
      
      private var _packs:Vector.<Label> = new Vector.<Label>(0);
      
      private var _counts:Vector.<Label> = new Vector.<Label>(0);
      
      private var _percents:Vector.<Label> = new Vector.<Label>(0);
      
      public function PreBlackFridaySalesUIView(param1:Sprite)
      {
         super();
         this._uiContainer = param1;
         this._fuiCache = new FuiComponentSelectorCache(this._uiContainer);
      }
      
      public function get title() : String
      {
         return "title_pre-blackfriday-sales";
      }
      
      public function get description() : Label
      {
         return this._fuiCache.selectComponent("root.overview.packs.description") as Label;
      }
      
      public function get packs() : Vector.<Label>
      {
         var _loc1_:int = 0;
         if(!this._packs || this._packs.length == 0)
         {
            this._packs = new Vector.<Label>(0);
            _loc1_ = 1;
            while(_loc1_ <= 5)
            {
               this._packs.push(this._fuiCache.selectComponent("root.overview.packs.pack0" + _loc1_) as Label);
               _loc1_++;
            }
         }
         return this._packs;
      }
      
      public function get header() : Label
      {
         return this._fuiCache.selectComponent("root.overview.discount.header") as Label;
      }
      
      public function get counts() : Vector.<Label>
      {
         var _loc1_:int = 0;
         if(!this._counts || this._counts.length == 0)
         {
            this._counts = new Vector.<Label>(0);
            _loc1_ = 1;
            while(_loc1_ <= 5)
            {
               this._counts.push(this._fuiCache.selectComponent("root.overview.discount.discount0" + _loc1_ + "_count") as Label);
               _loc1_++;
            }
         }
         return this._counts;
      }
      
      public function get percents() : Vector.<Label>
      {
         var _loc1_:int = 0;
         if(!this._percents || this._percents.length == 0)
         {
            this._percents = new Vector.<Label>(0);
            _loc1_ = 1;
            while(_loc1_ <= 5)
            {
               this._percents.push(this._fuiCache.selectComponent("root.overview.discount.discount0" + _loc1_ + "_percent") as Label);
               _loc1_++;
            }
         }
         return this._percents;
      }
      
      public function resetLabel() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._counts.length)
         {
            this._counts[_loc1_].registeredTextStyleName = "preblackfriday_discount_count_grey";
            this._percents[_loc1_].registeredTextStyleName = "preblackfriday_discount_percent_grey";
            _loc1_++;
         }
      }
      
      public function setLabelBought(param1:int) : void
      {
         if(param1 <= 0)
         {
            return;
         }
         var _loc2_:int = param1 - 1;
         this._counts[_loc2_].registeredTextStyleName = "preblackfriday_discount_count_white";
         this._percents[_loc2_].registeredTextStyleName = "preblackfriday_discount_percent_white";
      }
   }
}

