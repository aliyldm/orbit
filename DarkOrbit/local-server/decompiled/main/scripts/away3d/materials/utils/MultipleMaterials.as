package away3d.materials.utils
{
   import away3d.materials.MaterialBase;
   
   public class MultipleMaterials
   {
      
      private var _left:MaterialBase;
      
      private var _right:MaterialBase;
      
      private var _bottom:MaterialBase;
      
      private var _top:MaterialBase;
      
      private var _front:MaterialBase;
      
      private var _back:MaterialBase;
      
      public function MultipleMaterials(param1:MaterialBase = null, param2:MaterialBase = null, param3:MaterialBase = null, param4:MaterialBase = null, param5:MaterialBase = null)
      {
         super();
         this._left = param3;
         this._right = param4;
         this._bottom = this.bottom;
         this._top = param5;
         this._front = param1;
         this._back = param2;
      }
      
      public function get left() : MaterialBase
      {
         return this._left;
      }
      
      public function set left(param1:MaterialBase) : void
      {
         if(this._left == param1)
         {
            return;
         }
         this._left = param1;
      }
      
      public function get right() : MaterialBase
      {
         return this._right;
      }
      
      public function set right(param1:MaterialBase) : void
      {
         if(this._right == param1)
         {
            return;
         }
         this._right = param1;
      }
      
      public function get bottom() : MaterialBase
      {
         return this._bottom;
      }
      
      public function set bottom(param1:MaterialBase) : void
      {
         if(this._bottom == param1)
         {
            return;
         }
         this._bottom = param1;
      }
      
      public function get top() : MaterialBase
      {
         return this._top;
      }
      
      public function set top(param1:MaterialBase) : void
      {
         if(this._top == param1)
         {
            return;
         }
         this._top = param1;
      }
      
      public function get front() : MaterialBase
      {
         return this._front;
      }
      
      public function set front(param1:MaterialBase) : void
      {
         if(this._front == param1)
         {
            return;
         }
         this._front = param1;
      }
      
      public function get back() : MaterialBase
      {
         return this._back;
      }
      
      public function set back(param1:MaterialBase) : void
      {
         if(this._back == param1)
         {
            return;
         }
         this._back = param1;
      }
   }
}

