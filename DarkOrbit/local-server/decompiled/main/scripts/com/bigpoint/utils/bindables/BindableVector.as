package com.bigpoint.utils.bindables
{
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class BindableVector
   {
      
      private var _value:Vector.<Object> = new Vector.<Object>();
      
      private var _changed:ISignal = new Signal();
      
      private var _unique:Boolean;
      
      public function BindableVector(param1:Vector.<Object> = null, param2:Boolean = false)
      {
         super();
         this._value = param1 || this._value;
         this._unique = param2;
      }
      
      public function removeElement(param1:Object) : void
      {
         var _loc2_:int = this._value.indexOf(param1);
         if(_loc2_ != -1)
         {
            this._value.splice(_loc2_,1);
            this._changed.dispatch();
         }
      }
      
      private function hasElement(param1:Object) : Boolean
      {
         return this._value.indexOf(param1) != -1;
      }
      
      public function addElement(param1:Object) : void
      {
         if(this._unique)
         {
            if(!this.hasElement(param1))
            {
               this._value.push(param1);
               this._changed.dispatch();
            }
         }
         else
         {
            this._value.push(param1);
            this._changed.dispatch();
         }
      }
      
      public function getElementAt(param1:uint) : Object
      {
         return this._value[param1];
      }
      
      public function get changed() : ISignal
      {
         return this._changed;
      }
      
      public function get length() : uint
      {
         return this._value.length;
      }
      
      public function clear() : void
      {
         this._value.length = 0;
      }
      
      public function getFirstObjectByClass(param1:Class) : Object
      {
         var _loc2_:Object = null;
         for each(_loc2_ in this._value)
         {
            if(_loc2_ is param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function get value() : Vector.<Object>
      {
         return this._value;
      }
      
      public function set value(param1:Vector.<Object>) : void
      {
         this._value = param1;
         this._changed.dispatch();
      }
   }
}

