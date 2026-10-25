package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class QuestIconModule implements IModule
   {
      
      private static var _instance:QuestIconModule;
      
      public static const ICONTYPE_KILL:int = 0;
      
      public static const ICONTYPE_COLLECT:int = 1;
      
      public static const ICONTYPE_DISCOVER:int = 2;
      
      public static const ICONTYPE_PVP:int = 3;
      
      public static const ICONTYPE_TIME:int = 4;
      
      public static const ICONTYPE_SUMMERGAMES3:int = 5;
      
      public static const ICONTYPE_WINTERGAMES09:int = 6;
      
      public static const ICONTYPE_HALLOWEEN2012:int = 7;
      
      public static const ICONTYPE_EPIC:int = 8;
      
      public static const ICONTYPE_DAILY_QUEST_DIFFICULTY_LEVEL_EASY:int = 9;
      
      public static const ICONTYPE_DAILY_QUEST_DIFFICULTY_LEVEL_MEDIUM:int = 10;
      
      public static const ICONTYPE_DAILY_QUEST_DIFFICULTY_LEVEL_HARD:int = 11;
      
      public static const ICONTYPE__MAX:int = 12;
      
      public var icon:int = 0;
      
      public function QuestIconModule(param1:int = 0)
      {
         super();
         this.icon = param1;
      }
      
      public static function get instance() : QuestIconModule
      {
         return _instance || (_instance = new QuestIconModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return 2100;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 0;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.icon = param1.readShort();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(2100);
         param1.writeShort(this.icon);
      }
   }
}

