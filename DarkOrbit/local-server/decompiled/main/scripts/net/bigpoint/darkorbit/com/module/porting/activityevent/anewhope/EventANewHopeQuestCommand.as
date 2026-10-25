package net.bigpoint.darkorbit.com.module.porting.activityevent.anewhope
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   import net.bigpoint.darkorbit.com.module.porting.activityevent.*;
   
   public class EventANewHopeQuestCommand implements IModule
   {
      
      private static var _instance:EventANewHopeQuestCommand;
      
      public var dailyQuests:Vector.<EventQuestDefinitionModule>;
      
      public var noRepeatQuests:Vector.<EventQuestDefinitionModule>;
      
      public var noRepeatNextRefreshSecond:int = 0;
      
      public var dailyNextRefreshSecond:int = 0;
      
      public function EventANewHopeQuestCommand(param1:Vector.<EventQuestDefinitionModule> = null, param2:Vector.<EventQuestDefinitionModule> = null, param3:int = 0, param4:int = 0)
      {
         super();
         if(param1 == null)
         {
            this.dailyQuests = new Vector.<EventQuestDefinitionModule>();
         }
         else
         {
            this.dailyQuests = param1;
         }
         if(param2 == null)
         {
            this.noRepeatQuests = new Vector.<EventQuestDefinitionModule>();
         }
         else
         {
            this.noRepeatQuests = param2;
         }
         this.noRepeatNextRefreshSecond = param4;
         this.dailyNextRefreshSecond = param3;
      }
      
      public static function get instance() : EventANewHopeQuestCommand
      {
         return _instance || (_instance = new EventANewHopeQuestCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -11502;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 16;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:EventQuestDefinitionModule = null;
         var _loc5_:EventQuestDefinitionModule = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.dailyQuests.length > 0)
         {
            this.dailyQuests.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = EventQuestDefinitionModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.dailyQuests.push(_loc4_);
            _loc2_++;
         }
         while(this.noRepeatQuests.length > 0)
         {
            this.noRepeatQuests.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc5_ = EventQuestDefinitionModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc5_.read(param1);
            this.noRepeatQuests.push(_loc5_);
            _loc2_++;
         }
         this.noRepeatNextRefreshSecond = param1.readInt();
         this.noRepeatNextRefreshSecond = this.noRepeatNextRefreshSecond << 6 % 32 | this.noRepeatNextRefreshSecond >>> 32 - 6 % 32;
         this.dailyNextRefreshSecond = param1.readInt();
         this.dailyNextRefreshSecond = this.dailyNextRefreshSecond >>> 12 % 32 | this.dailyNextRefreshSecond << 32 - 12 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:EventQuestDefinitionModule = null;
         var _loc3_:EventQuestDefinitionModule = null;
         param1.writeShort(-11502);
         param1.writeByte(this.dailyQuests.length);
         for each(_loc2_ in this.dailyQuests)
         {
            _loc2_.write(param1);
         }
         param1.writeByte(this.noRepeatQuests.length);
         for each(_loc3_ in this.noRepeatQuests)
         {
            _loc3_.write(param1);
         }
         param1.writeInt(this.noRepeatNextRefreshSecond >>> 6 % 32 | this.noRepeatNextRefreshSecond << 32 - 6 % 32);
         param1.writeInt(this.dailyNextRefreshSecond << 12 % 32 | this.dailyNextRefreshSecond >>> 32 - 12 % 32);
      }
   }
}

