package net.bigpoint.darkorbit.map.common.lensflares
{
   import com.bigpoint.utils.PointLite;
   
   public class LensFlareVO
   {
      
      private var _blendMode:String;
      
      private var _typeID:int;
      
      private var _id:int;
      
      private var _worldPosition:PointLite;
      
      private var _isStar:Boolean;
      
      public function LensFlareVO(param1:int, param2:int, param3:PointLite, param4:Boolean, param5:String = null)
      {
         super();
         this._id = param1;
         this._typeID = param2;
         this._worldPosition = param3;
         this._isStar = param4;
         this._blendMode = param5;
      }
      
      public function get typeID() : int
      {
         return this._typeID;
      }
      
      public function get id() : int
      {
         return this._id;
      }
      
      public function get worldPosition() : PointLite
      {
         return this._worldPosition;
      }
      
      public function get isStar() : Boolean
      {
         return this._isStar;
      }
      
      public function get blendMode() : String
      {
         return this._blendMode;
      }
   }
}

