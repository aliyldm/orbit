package net.bigpoint.darkorbit.loadingscreen.mvc.bonuscalendar.model.vo
{
   import net.bigpoint.darkorbit.loadingscreen.utils.Session;
   
   public class ItemVO
   {
      
      private static var __ID__:uint = 0;
      
      private var _ID:String;
      
      private var _path:String = "";
      
      private var _amount:uint = 0;
      
      private var _index:uint;
      
      private var _booked:Boolean = false;
      
      private var _special:Boolean;
      
      private var _active:Boolean;
      
      private var _premium:Boolean;
      
      private var _lootID:String;
      
      private var _isPremium:Boolean;
      
      public function ItemVO(param1:uint = 0, param2:String = null, param3:uint = 0, param4:Boolean = false, param5:Boolean = false, param6:Boolean = false, param7:Boolean = false)
      {
         super();
         this._index = param1;
         this._path = param2;
         this._booked = param4;
         this._special = param5;
         this._active = param6;
         this._isPremium = param7;
      }
      
      public function get ID() : uint
      {
         return ++__ID__;
      }
      
      public function get lootID() : String
      {
         return this._lootID;
      }
      
      public function isSpecial() : Boolean
      {
         return this._special;
      }
      
      public function isBooked() : Boolean
      {
         return this._booked;
      }
      
      public function get path() : String
      {
         return this._path;
      }
      
      public function get fullPath() : String
      {
         return Session.host + this._path;
      }
      
      public function get index() : uint
      {
         return this._index;
      }
      
      public function get amount() : uint
      {
         return this._amount;
      }
      
      public function get isPremium() : Boolean
      {
         return this._isPremium;
      }
      
      public function set isPremium(param1:Boolean) : void
      {
         this._isPremium = param1;
      }
      
      public function isActive() : Boolean
      {
         return this._active;
      }
      
      public function parse(param1:Object) : void
      {
         this._index = this.ID;
         this._lootID = param1.lootId;
         this._path = param1.lootImage;
         this._special = param1.special;
         this._premium = param1.premium;
         if(param1.hasOwnProperty("amount"))
         {
            this._amount = param1.amount;
         }
         else
         {
            this._amount = 0;
         }
         if(param1.hasOwnProperty("booked"))
         {
            this._booked = param1.booked;
         }
         if(param1.hasOwnProperty("next"))
         {
            this._active = param1.next;
         }
      }
      
      public function toString() : String
      {
         var _loc1_:String = "{ ";
         _loc1_ += " _index  : " + this._index;
         _loc1_ += " _lootID : " + this._lootID;
         _loc1_ += " _path   : " + this._path;
         _loc1_ += " amout   : " + this._amount;
         _loc1_ += " booked  : " + this._booked;
         return _loc1_ + " }";
      }
   }
}

