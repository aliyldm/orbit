package net.bigpoint.darkorbit.com.module.porting.activityevent.unityclientreward
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   import net.bigpoint.darkorbit.com.module.porting.activityevent.*;
   
   public class EventUnityClientRewardQuestCommand implements IModule
   {
      
      private static var _instance:EventUnityClientRewardQuestCommand;
      
      public var nowQuests:EventQuestListCommand;
      
      public var afterQuests:Vector.<EventQuestListCommand>;
      
      public var beforeQuests:Vector.<EventQuestListCommand>;
      
      public function EventUnityClientRewardQuestCommand(param1:Vector.<EventQuestListCommand> = null, param2:EventQuestListCommand = null, param3:Vector.<EventQuestListCommand> = null)
      {
         super();
         if(param2 == null)
         {
            this.nowQuests = new EventQuestListCommand();
         }
         else
         {
            this.nowQuests = param2;
         }
         if(param3 == null)
         {
            this.afterQuests = new Vector.<EventQuestListCommand>();
         }
         else
         {
            this.afterQuests = param3;
         }
         if(param1 == null)
         {
            this.beforeQuests = new Vector.<EventQuestListCommand>();
         }
         else
         {
            this.beforeQuests = param1;
         }
      }
      
      public static function get instance() : EventUnityClientRewardQuestCommand
      {
         return _instance || (_instance = new EventUnityClientRewardQuestCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -7716;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 8;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:EventQuestListCommand = null;
         var _loc5_:EventQuestListCommand = null;
         this.nowQuests = EventQuestListCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.nowQuests)
         {
            this.nowQuests.read(param1);
         }
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.afterQuests.length > 0)
         {
            this.afterQuests.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = EventQuestListCommand(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.afterQuests.push(_loc4_);
            _loc2_++;
         }
         while(this.beforeQuests.length > 0)
         {
            this.beforeQuests.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc5_ = EventQuestListCommand(ModuleFactory.get().createInstance(param1.readShort()));
            _loc5_.read(param1);
            this.beforeQuests.push(_loc5_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:EventQuestListCommand = null;
         var _loc3_:EventQuestListCommand = null;
         param1.writeShort(-7716);
         if(null != this.nowQuests)
         {
            this.nowQuests.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeByte(this.afterQuests.length);
         for each(_loc2_ in this.afterQuests)
         {
            _loc2_.write(param1);
         }
         param1.writeByte(this.beforeQuests.length);
         for each(_loc3_ in this.beforeQuests)
         {
            _loc3_.write(param1);
         }
      }
   }
}

