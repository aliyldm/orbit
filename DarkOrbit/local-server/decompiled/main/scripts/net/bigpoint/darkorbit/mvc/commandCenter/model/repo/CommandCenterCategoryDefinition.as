package net.bigpoint.darkorbit.mvc.commandCenter.model.repo
{
   public class CommandCenterCategoryDefinition
   {
      
      private var _id:String;
      
      private var _isSpecial:Boolean;
      
      private var _textkey:String;
      
      private var _prio:int;
      
      public function CommandCenterCategoryDefinition(param1:String, param2:Boolean, param3:String, param4:int)
      {
         super();
         this._id = param1;
         this._isSpecial = param2;
         this._textkey = param3;
         this._prio = param4;
      }
      
      public function get id() : String
      {
         return this._id;
      }
      
      public function get isSpecial() : Boolean
      {
         return this._isSpecial;
      }
      
      public function get textkey() : String
      {
         return this._textkey;
      }
      
      public function get prio() : int
      {
         return this._prio;
      }
   }
}

