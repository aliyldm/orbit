package com.bigpoint.utils
{
   import org.as3commons.lang.StringUtils;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class StringPair
   {
      
      public const changed:ISignal = new Signal();
      
      private var _right:String;
      
      private var _left:String;
      
      public function StringPair(param1:String = null, param2:String = null)
      {
         super();
         this._left = param1;
         this._right = param2;
      }
      
      public static function sortLeft(param1:StringPair, param2:StringPair) : int
      {
         return StringUtils.compareTo(param1.left,param2.left) || sortRight(param1,param2);
      }
      
      public static function sortRight(param1:StringPair, param2:StringPair) : int
      {
         return StringUtils.compareTo(param1.right,param2.right) || sortLeft(param1,param2);
      }
      
      public function get right() : String
      {
         return this._right;
      }
      
      public function set right(param1:String) : void
      {
         if(this._right != param1)
         {
            this._right = param1;
            this.changed.dispatch();
         }
      }
      
      public function get left() : String
      {
         return this._left;
      }
      
      public function set left(param1:String) : void
      {
         if(this._left != param1)
         {
            this._left = param1;
            this.changed.dispatch();
         }
      }
      
      public function toString() : String
      {
         return this._left + "" + this._right;
      }
   }
}

