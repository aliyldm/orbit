package net.bigpoint.darkorbit.com.module.porting.activityevent
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   
   public class EventQuestListCommand implements IModule
   {
      
      private static var _instance:EventQuestListCommand;
      
      public var quests:Vector.<EventQuestDefinitionModule>;
      
      public function EventQuestListCommand(param1:Vector.<EventQuestDefinitionModule> = null)
      {
         super();
         if(param1 == null)
         {
            this.quests = new Vector.<EventQuestDefinitionModule>();
         }
         else
         {
            this.quests = param1;
         }
      }
      
      public static function get instance() : EventQuestListCommand
      {
         return _instance || (_instance = new EventQuestListCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -13281;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:EventQuestDefinitionModule = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.quests.length > 0)
         {
            this.quests.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = EventQuestDefinitionModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.quests.push(_loc4_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:EventQuestDefinitionModule = null;
         param1.writeShort(-13281);
         param1.writeByte(this.quests.length);
         for each(_loc2_ in this.quests)
         {
            _loc2_.write(param1);
         }
      }
   }
}

