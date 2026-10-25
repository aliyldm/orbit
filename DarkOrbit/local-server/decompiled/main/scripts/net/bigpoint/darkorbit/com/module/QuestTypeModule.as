package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class QuestTypeModule implements IModule
   {
      
      private static var _instance:QuestTypeModule;
      
      public static const QUESTTYPE_UNDEFINED:int = 0;
      
      public static const QUESTTYPE_STARTER:int = 1;
      
      public static const QUESTTYPE_MISSION:int = 2;
      
      public static const QUESTTYPE_DAILY:int = 3;
      
      public static const QUESTTYPE_CHALLENGE:int = 4;
      
      public static const QUESTTYPE_EVENT:int = 5;
      
      public static const QUESTTYPE_WEEKLY:int = 6;
      
      public static const QUESTTYPE_BATTLEPASS:int = 7;
      
      public static const QUESTTYPE_DIMINISHING:int = 8;
      
      public static const QUESTTYPE_SEASONPASS:int = 9;
      
      public static const QUESTTYPE_FREE_PERIOD:int = 10;
      
      public static const QUESTTYPE__MAX:int = 11;
      
      public var type:int = 0;
      
      public function QuestTypeModule(param1:int = 0)
      {
         super();
         this.type = param1;
      }
      
      public static function get instance() : QuestTypeModule
      {
         return _instance || (_instance = new QuestTypeModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return 4141;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 0;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.type = param1.readShort();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(4141);
         param1.writeShort(this.type);
      }
   }
}

