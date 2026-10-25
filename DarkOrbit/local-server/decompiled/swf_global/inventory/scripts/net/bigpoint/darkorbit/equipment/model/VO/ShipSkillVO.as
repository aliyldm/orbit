package net.bigpoint.darkorbit.equipment.model.VO
{
   public class ShipSkillVO
   {
      
      private var _name:String;
      
      private var _iconPath:String;
      
      private var _text:String;
      
      public function ShipSkillVO(param1:String, param2:String, param3:String)
      {
         super();
         this._name = param1;
         this._iconPath = param2;
         this._text = param3;
      }
      
      public function get iconPath() : String
      {
         return this._iconPath;
      }
      
      public function get text() : String
      {
         return this._text;
      }
      
      public function get name() : String
      {
         return this._name;
      }
   }
}

