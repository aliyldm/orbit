package away3d.materials.compilation
{
   public class ShaderRegisterElement
   {
      
      private static const COMPONENTS:Array = ["x","y","z","w"];
      
      private var _regName:String;
      
      private var _index:int;
      
      private var _toStr:String;
      
      internal var _component:int;
      
      public function ShaderRegisterElement(param1:String, param2:int, param3:int = -1)
      {
         super();
         this._component = param3;
         this._regName = param1;
         this._index = param2;
         this._toStr = this._regName;
         if(this._index >= 0)
         {
            this._toStr += this._index;
         }
         if(param3 > -1)
         {
            this._toStr += "." + COMPONENTS[param3];
         }
      }
      
      public function toString() : String
      {
         return this._toStr;
      }
      
      public function get regName() : String
      {
         return this._regName;
      }
      
      public function get index() : int
      {
         return this._index;
      }
   }
}

