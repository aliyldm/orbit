package net.bigpoint.darkorbit.managers.keyboardManager.parser
{
   import net.bigpoint.darkorbit.managers.keyboardManager.KeyValuePair;
   
   public class SettingsWindowKeyboardParser implements IKeyboardParser
   {
      
      private var keyMap:Object = new Object();
      
      public function SettingsWindowKeyboardParser()
      {
         super();
      }
      
      public function addKeyValuePair(param1:int, param2:Vector.<String>, param3:String) : void
      {
         this.keyMap[param1.toString()] = new Vector.<Object>(1);
         (this.keyMap[param1.toString()] as Vector.<Object>)[0] = new Object();
         this.keyMap[param1.toString()][0][KeyboardXmlParser.NAME] = param3;
         this.keyMap[param1.toString()][0][KeyboardXmlParser.PARAMS] = new Object();
         this.keyMap[param1.toString()][0][KeyboardXmlParser.PARAMS][this.keyMap[param1.toString()][0][KeyboardXmlParser.NAME]] = param2;
      }
      
      public function addFullKeyValuePair(param1:KeyValuePair) : void
      {
         var _loc2_:String = null;
         if(param1.keys.length > 0)
         {
            _loc2_ = param1.keys[0].toString();
            this.keyMap[_loc2_] = new Vector.<Object>(1);
            (this.keyMap[_loc2_] as Vector.<Object>)[0] = new Object();
            this.keyMap[_loc2_][0][KeyboardXmlParser.NAME] = param1.name;
            this.keyMap[_loc2_][0][KeyboardXmlParser.PARAMS] = new Object();
            this.keyMap[_loc2_][0][KeyboardXmlParser.PARAMS][this.keyMap[_loc2_.toString()][0][KeyboardXmlParser.NAME]] = param1.args;
         }
      }
      
      public function parse() : Object
      {
         return this.keyMap;
      }
      
      public function reset() : void
      {
         this.keyMap = new Object();
      }
      
      public function getCommandNames() : Vector.<KeyValuePair>
      {
         var _loc2_:KeyValuePair = null;
         var _loc3_:String = null;
         var _loc1_:Vector.<KeyValuePair> = new Vector.<KeyValuePair>();
         for(_loc3_ in this.keyMap)
         {
            if((this.keyMap[_loc3_] as Vector.<Object>)[0][KeyboardXmlParser.NAME])
            {
               _loc2_ = new KeyValuePair();
               _loc2_.keys = new <int>[int(_loc3_)];
               _loc2_.name = (this.keyMap[_loc3_.toString()] as Vector.<Object>)[0][KeyboardXmlParser.NAME];
               _loc2_.args = this.keyMap[_loc3_.toString()][0][KeyboardXmlParser.PARAMS][this.keyMap[_loc3_.toString()][0][KeyboardXmlParser.NAME]];
               _loc1_.push(_loc2_);
            }
         }
         return _loc1_;
      }
   }
}

