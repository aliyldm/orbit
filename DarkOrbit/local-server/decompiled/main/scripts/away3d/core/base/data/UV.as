package away3d.core.base.data
{
   public class UV
   {
      
      private var _u:Number;
      
      private var _v:Number;
      
      public function UV(param1:Number = 0, param2:Number = 0)
      {
         super();
         this._u = param1;
         this._v = param2;
      }
      
      public function get v() : Number
      {
         return this._v;
      }
      
      public function set v(param1:Number) : void
      {
         this._v = param1;
      }
      
      public function get u() : Number
      {
         return this._u;
      }
      
      public function set u(param1:Number) : void
      {
         this._u = param1;
      }
      
      public function clone() : UV
      {
         return new UV(this._u,this._v);
      }
      
      public function toString() : String
      {
         return this._u + "," + this._v;
      }
   }
}

