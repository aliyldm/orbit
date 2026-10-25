package net.bigpoint.darkorbit.mvc.commandCenter.model.repo
{
   import net.bigpoint.darkorbit.mvc.commandCenter.constants.CommandCenterConsts;
   import net.bigpoint.darkorbit.mvc.common.utils.ParserUtility;
   
   public class CommandCenterNewsDefinition
   {
      
      private var _configXML:XML;
      
      private var _assignmentsXML:XML;
      
      private var _actionsXML:XML;
      
      private var _name:String;
      
      private var _prio:int;
      
      private var _category:String;
      
      private var _showCountDown:Boolean;
      
      private var _categoryOverrideKey:String;
      
      public function CommandCenterNewsDefinition()
      {
         super();
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function get prio() : int
      {
         return this._prio;
      }
      
      public function get category() : String
      {
         return this._category;
      }
      
      public function get assignmentsXML() : XML
      {
         return this._assignmentsXML;
      }
      
      public function get actionsXML() : XML
      {
         return this._actionsXML;
      }
      
      public function get showCountDown() : Boolean
      {
         return this._showCountDown;
      }
      
      public function get categoryOverrideKey() : String
      {
         return this._categoryOverrideKey;
      }
      
      public function getEventNames() : Vector.<String>
      {
         var _loc3_:XML = null;
         var _loc1_:Vector.<String> = new Vector.<String>(0);
         var _loc2_:XMLList = this._configXML.child("event");
         for each(_loc3_ in _loc2_)
         {
            _loc1_.push(String(_loc3_.attribute("id")));
         }
         _loc1_.push(CommandCenterConsts.NEWS_EVENT_PREFIX + this._name);
         return _loc1_;
      }
      
      public function parse(param1:XML) : void
      {
         this._name = String(param1.attribute("name"));
         this._prio = int(param1.attribute("prio"));
         this._showCountDown = ParserUtility.parseBooleanFromInt(int(param1.attribute("countdown")));
         this._configXML = param1.child("config")[0];
         this._category = String(param1.attribute("category"));
         var _loc2_:String = String(param1.attribute("categoryOverrideKey"));
         this._categoryOverrideKey = _loc2_.length > 0 ? _loc2_ : null;
         this._assignmentsXML = param1.child("assignments")[0];
         this._actionsXML = param1.child("actions")[0];
      }
      
      public function toString() : String
      {
         return "CommandCenterNewsDefinition{_name=" + String(this._name) + ",_prio=" + String(this._prio) + ",_category=" + String(this._category) + ",_showCountDown=" + String(this._showCountDown) + "}";
      }
   }
}

