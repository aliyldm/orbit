package net.bigpoint.darkorbit.mvc.gui.windows.preBlackFridaySales.model
{
   import com.bigpoint.utils.bindables.BindableInt;
   import flash.events.EventDispatcher;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.com.module.PreBlackFridaySalesInfoCommand;
   
   public class PreBlackFridaySalesUIData extends EventDispatcher
   {
      
      public const description:String = "pre-blackfriday-sales_description";
      
      public const header:String = "pre-blackfriday-sales_discount_header";
      
      private const _packPrefix:String = "items_package_event-deal-pre-bf-";
      
      private const _countPrefix:String = "pre-blackfriday-sales_bought";
      
      private const _percentPrefix:String = "pre-blackfriday-sales_discount";
      
      public var boughtCount:BindableInt = new BindableInt(0,0,5);
      
      private var _packs:Vector.<String> = new Vector.<String>(0);
      
      private var _counts:Vector.<String> = new Vector.<String>(0);
      
      private var _percents:Vector.<String> = new Vector.<String>(0);
      
      public function PreBlackFridaySalesUIData()
      {
         super();
      }
      
      public function updateInfo(param1:PreBlackFridaySalesInfoCommand) : void
      {
         this.boughtCount.value = param1.packBought;
         this.boughtCount.changed.dispatch();
      }
      
      public function get packs() : Vector.<String>
      {
         var _loc1_:int = 0;
         if(!this._packs || this._packs.length == 0)
         {
            this._packs = new Vector.<String>(0);
            _loc1_ = 1;
            while(_loc1_ <= 5)
            {
               this._packs.push(BPLocale.getItemInCategory("items",this._packPrefix + _loc1_ + "_fullname"));
               _loc1_++;
            }
         }
         return this._packs;
      }
      
      public function get counts() : Vector.<String>
      {
         var _loc1_:int = 0;
         if(!this._counts || this._counts.length == 0)
         {
            this._counts = new Vector.<String>(0);
            _loc1_ = 1;
            while(_loc1_ <= 5)
            {
               this._counts.push(this._countPrefix + _loc1_);
               _loc1_++;
            }
         }
         return this._counts;
      }
      
      public function get percents() : Vector.<String>
      {
         var _loc1_:int = 0;
         if(!this._percents || this._percents.length == 0)
         {
            this._percents = new Vector.<String>(0);
            _loc1_ = 1;
            while(_loc1_ <= 5)
            {
               this._percents.push(this._percentPrefix + _loc1_);
               _loc1_++;
            }
         }
         return this._percents;
      }
   }
}

