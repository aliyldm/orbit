package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.liveops.seasonpass.*;
   
   public class SeasonPassMissionInfoCommand implements IModule
   {
      
      private static var _instance:SeasonPassMissionInfoCommand;
      
      public static const MISSIONINFOTYPE_REPLACE:int = 0;
      
      public static const MISSIONINFOTYPE_APPEND:int = 1;
      
      public static const MISSIONINFOTYPE__MAX:int = 2;
      
      public var refreshInfo:RefreshQuestInfo;
      
      public var missionInfoType:int = 0;
      
      public var missionItems:Vector.<SeasonPassMissionModule>;
      
      public function SeasonPassMissionInfoCommand(param1:int = 0, param2:Vector.<SeasonPassMissionModule> = null, param3:RefreshQuestInfo = null)
      {
         super();
         if(param3 == null)
         {
            this.refreshInfo = new RefreshQuestInfo();
         }
         else
         {
            this.refreshInfo = param3;
         }
         this.missionInfoType = param1;
         if(param2 == null)
         {
            this.missionItems = new Vector.<SeasonPassMissionModule>();
         }
         else
         {
            this.missionItems = param2;
         }
      }
      
      public static function get instance() : SeasonPassMissionInfoCommand
      {
         return _instance || (_instance = new SeasonPassMissionInfoCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -21317;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:SeasonPassMissionModule = null;
         this.refreshInfo = RefreshQuestInfo(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.refreshInfo)
         {
            this.refreshInfo.read(param1);
         }
         this.missionInfoType = param1.readShort();
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.missionItems.length > 0)
         {
            this.missionItems.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = SeasonPassMissionModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.missionItems.push(_loc4_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:SeasonPassMissionModule = null;
         param1.writeShort(-21317);
         if(null != this.refreshInfo)
         {
            this.refreshInfo.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeShort(this.missionInfoType);
         param1.writeByte(this.missionItems.length);
         for each(_loc2_ in this.missionItems)
         {
            _loc2_.write(param1);
         }
      }
   }
}

