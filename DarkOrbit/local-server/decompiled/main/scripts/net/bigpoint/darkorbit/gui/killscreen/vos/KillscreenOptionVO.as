package net.bigpoint.darkorbit.gui.killscreen.vos
{
   import com.greensock.TweenLite;
   
   public class KillscreenOptionVO
   {
      
      private var _priceType:int;
      
      private var _graphic:String;
      
      private var _tooltip:String;
      
      private var _priceColor:uint;
      
      private var _buttonKey:String;
      
      private var _detailText:String;
      
      private var _wildcard:String;
      
      private var _repairCost:int;
      
      private var _affordable:Boolean;
      
      private var _cooldown:int;
      
      private var _cooldownTween:TweenLite;
      
      private var _currency:String;
      
      public function KillscreenOptionVO(param1:String, param2:String, param3:uint, param4:String, param5:String)
      {
         super();
         this._detailText = param5;
         this._buttonKey = param4;
         this._priceColor = param3;
         this._tooltip = param2;
         this._graphic = param1;
      }
      
      public function get graphic() : String
      {
         return this._graphic;
      }
      
      public function set graphic(param1:String) : void
      {
         this._graphic = param1;
      }
      
      public function get tooltip() : String
      {
         return this._tooltip;
      }
      
      public function set tooltip(param1:String) : void
      {
         this._tooltip = param1;
      }
      
      public function get priceColor() : uint
      {
         return this._priceColor;
      }
      
      public function set priceColor(param1:uint) : void
      {
         this._priceColor = param1;
      }
      
      public function get buttonKey() : String
      {
         return this._buttonKey;
      }
      
      public function set buttonKey(param1:String) : void
      {
         this._buttonKey = param1;
      }
      
      public function get detailText() : String
      {
         return this._detailText;
      }
      
      public function set detailText(param1:String) : void
      {
         this._detailText = param1;
      }
      
      public function get wildcard() : String
      {
         return this._wildcard;
      }
      
      public function set wildcard(param1:String) : void
      {
         this._wildcard = param1;
      }
      
      public function set repairCost(param1:int) : void
      {
         this._repairCost = param1;
      }
      
      public function set affordable(param1:Boolean) : void
      {
         this._affordable = param1;
      }
      
      public function set cooldown(param1:int) : void
      {
         this._cooldown = param1;
      }
      
      public function get cooldownTween() : TweenLite
      {
         return this._cooldownTween;
      }
      
      public function get cooldown() : int
      {
         return this._cooldown;
      }
      
      public function set cooldownTween(param1:TweenLite) : void
      {
         this._cooldownTween = param1;
      }
      
      public function get repairCost() : int
      {
         return this._repairCost;
      }
      
      public function get affordable() : Boolean
      {
         return this._affordable;
      }
      
      public function set currency(param1:String) : void
      {
         this._currency = param1;
      }
      
      public function get currency() : String
      {
         return this._currency;
      }
      
      public function get priceType() : int
      {
         return this._priceType;
      }
      
      public function set priceType(param1:int) : void
      {
         this._priceType = param1;
      }
   }
}

