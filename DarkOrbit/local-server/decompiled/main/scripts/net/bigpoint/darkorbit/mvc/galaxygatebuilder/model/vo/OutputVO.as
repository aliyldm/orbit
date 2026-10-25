package net.bigpoint.darkorbit.mvc.galaxygatebuilder.model.vo
{
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   
   public class OutputVO
   {
      
      public static const CAT_PART:int = 1;
      
      public static const CAT_MULTIPLIER:int = 2;
      
      public static const CAT_LOGFILES:int = 4;
      
      public static const CAT_VOUCHER:int = 8;
      
      public static const CAT_SPECIAL:int = 16;
      
      public static const CAT_RESOURCE:int = 32;
      
      public static const CAT_AMMUNITION:int = 64;
      
      public static const CAT_SPLITTER:int = 128;
      
      protected var _category:int;
      
      protected var _amount:int;
      
      protected var _multiplierAmount:int = 0;
      
      protected var _multiplierUsed:int = 0;
      
      protected var _spins:int = 1;
      
      protected var _date:Date;
      
      protected var _quiet:Boolean;
      
      public function OutputVO(param1:int, param2:int, param3:Date)
      {
         super();
         this._category = param1;
         this._amount = param2;
         this._date = param3;
      }
      
      public function get category() : int
      {
         return this._category;
      }
      
      public function set category(param1:int) : void
      {
         this._category = param1;
      }
      
      public function get amount() : int
      {
         return this._amount;
      }
      
      public function set amount(param1:int) : void
      {
         this._amount = param1;
      }
      
      public function get date() : Date
      {
         return this._date;
      }
      
      public function set date(param1:Date) : void
      {
         this._date = param1;
      }
      
      public function get multiplierAmount() : int
      {
         return this._multiplierAmount;
      }
      
      public function set multiplierAmount(param1:int) : void
      {
         this._multiplierAmount = param1;
      }
      
      public function get multiplierUsed() : int
      {
         return this._multiplierUsed;
      }
      
      public function set multiplierUsed(param1:int) : void
      {
         this._multiplierUsed = param1;
      }
      
      public function get spins() : int
      {
         return this._spins;
      }
      
      public function set spins(param1:int) : void
      {
         this._spins = param1;
      }
      
      public function toString() : String
      {
         var _loc1_:String = null;
         var _loc2_:RegExp = /%COUNT%/;
         switch(this._category)
         {
            case OutputVO.CAT_RESOURCE:
               _loc1_ = BPLocale.getItemInCategory("galaxyGates","log_entry_resource").replace(_loc2_,this._amount);
               _loc1_ = _loc1_.replace(/%TYPE%/,"Xenomit");
               break;
            case OutputVO.CAT_VOUCHER:
               if(this._amount == 1)
               {
                  _loc1_ = BPLocale.getItemInCategory("galaxyGates","log_entry_repair_voucher_s");
               }
               else
               {
                  _loc1_ = BPLocale.getItemInCategory("galaxyGates","log_entry_repair_voucher_p").replace(_loc2_,this._amount);
               }
               break;
            case OutputVO.CAT_LOGFILES:
               if(this._amount == 1)
               {
                  _loc1_ = BPLocale.getItemInCategory("galaxyGates","log_entry_logfiles_s");
               }
               else
               {
                  _loc1_ = BPLocale.getItemInCategory("galaxyGates","log_entry_logfiles_p").replace(_loc2_,this._amount);
               }
               break;
            case OutputVO.CAT_MULTIPLIER:
               if(this._amount == 1)
               {
                  _loc1_ = BPLocale.getItemInCategory("galaxyGates","log_entry_multiplier_s");
               }
               else
               {
                  _loc1_ = BPLocale.getItemInCategory("galaxyGates","log_entry_multiplier_p").replace(_loc2_,this._amount);
               }
               break;
            default:
               _loc1_ = "";
         }
         return _loc1_;
      }
      
      public function get quiet() : Boolean
      {
         return this._quiet;
      }
      
      public function set quiet(param1:Boolean) : void
      {
         this._quiet = param1;
      }
   }
}

