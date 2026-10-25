package com.coolorus.panel.core.utils.color
{
   import org.osflash.signals.ISignal;
   
   public interface IColor
   {
      
      function get rawColor() : uint;
      
      function set rawColor(param1:uint) : void;
      
      function get alpha() : Number;
      
      function set alpha(param1:Number) : void;
      
      function clone() : IColor;
      
      function equals(param1:IColor) : Boolean;
      
      function copyFrom(param1:IColor, param2:Boolean = true) : void;
      
      function get changed() : ISignal;
      
      function setUndefined() : void;
      
      function isUndefined() : Boolean;
      
      function set id(param1:String) : void;
      
      function get hex() : String;
   }
}

