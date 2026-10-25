package net.bigpoint.darkorbit.com.module.porting.trinitytrials
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   import net.bigpoint.darkorbit.com.module.porting.*;
   
   public class TrinityTrialsDropLevelCommand implements IModule
   {
      
      private static var _instance:TrinityTrialsDropLevelCommand;
      
      public var costLootAmount:int = 0;
      
      public var currentLevel:int = 0;
      
      public var nextLevel:int = 0;
      
      public var building:Boolean = false;
      
      public var max:Boolean = false;
      
      public var skipConsume:int = 0;
      
      public var currentLevelQualityRandomList:Vector.<TupleTwoModule>;
      
      public var totalBuildSeconds:int = 0;
      
      public var lootAmount:int = 0;
      
      public var nextLevelQualityRandomList:Vector.<TupleTwoModule>;
      
      public var buildSeconds:int = 0;
      
      public var costLootId:String = "";
      
      public function TrinityTrialsDropLevelCommand(param1:int = 0, param2:int = 0, param3:Vector.<TupleTwoModule> = null, param4:Vector.<TupleTwoModule> = null, param5:String = "", param6:int = 0, param7:int = 0, param8:Boolean = false, param9:int = 0, param10:int = 0, param11:Boolean = false, param12:int = 0)
      {
         super();
         this.costLootAmount = param6;
         this.currentLevel = param1;
         this.nextLevel = param2;
         this.building = param8;
         this.max = param11;
         this.skipConsume = param10;
         if(param3 == null)
         {
            this.currentLevelQualityRandomList = new Vector.<TupleTwoModule>();
         }
         else
         {
            this.currentLevelQualityRandomList = param3;
         }
         this.totalBuildSeconds = param12;
         this.lootAmount = param7;
         if(param4 == null)
         {
            this.nextLevelQualityRandomList = new Vector.<TupleTwoModule>();
         }
         else
         {
            this.nextLevelQualityRandomList = param4;
         }
         this.buildSeconds = param9;
         this.costLootId = param5;
      }
      
      public static function get instance() : TrinityTrialsDropLevelCommand
      {
         return _instance || (_instance = new TrinityTrialsDropLevelCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 21794;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 40;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:TupleTwoModule = null;
         var _loc5_:TupleTwoModule = null;
         this.costLootAmount = param1.readInt();
         this.costLootAmount = this.costLootAmount >>> 5 % 32 | this.costLootAmount << 32 - 5 % 32;
         this.currentLevel = param1.readInt();
         this.currentLevel = this.currentLevel >>> 15 % 32 | this.currentLevel << 32 - 15 % 32;
         this.nextLevel = param1.readInt();
         this.nextLevel = this.nextLevel << 5 % 32 | this.nextLevel >>> 32 - 5 % 32;
         this.building = param1.readBoolean();
         this.max = param1.readBoolean();
         this.skipConsume = param1.readInt();
         this.skipConsume = this.skipConsume >>> 6 % 32 | this.skipConsume << 32 - 6 % 32;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.currentLevelQualityRandomList.length > 0)
         {
            this.currentLevelQualityRandomList.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = TupleTwoModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.currentLevelQualityRandomList.push(_loc4_);
            _loc2_++;
         }
         this.totalBuildSeconds = param1.readInt();
         this.totalBuildSeconds = this.totalBuildSeconds >>> 11 % 32 | this.totalBuildSeconds << 32 - 11 % 32;
         this.lootAmount = param1.readInt();
         this.lootAmount = this.lootAmount >>> 13 % 32 | this.lootAmount << 32 - 13 % 32;
         while(this.nextLevelQualityRandomList.length > 0)
         {
            this.nextLevelQualityRandomList.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc5_ = TupleTwoModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc5_.read(param1);
            this.nextLevelQualityRandomList.push(_loc5_);
            _loc2_++;
         }
         this.buildSeconds = param1.readInt();
         this.buildSeconds = this.buildSeconds >>> 15 % 32 | this.buildSeconds << 32 - 15 % 32;
         this.costLootId = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:TupleTwoModule = null;
         var _loc3_:TupleTwoModule = null;
         param1.writeShort(21794);
         param1.writeInt(this.costLootAmount << 5 % 32 | this.costLootAmount >>> 32 - 5 % 32);
         param1.writeInt(this.currentLevel << 15 % 32 | this.currentLevel >>> 32 - 15 % 32);
         param1.writeInt(this.nextLevel >>> 5 % 32 | this.nextLevel << 32 - 5 % 32);
         param1.writeBoolean(this.building);
         param1.writeBoolean(this.max);
         param1.writeInt(this.skipConsume << 6 % 32 | this.skipConsume >>> 32 - 6 % 32);
         param1.writeByte(this.currentLevelQualityRandomList.length);
         for each(_loc2_ in this.currentLevelQualityRandomList)
         {
            _loc2_.write(param1);
         }
         param1.writeInt(this.totalBuildSeconds << 11 % 32 | this.totalBuildSeconds >>> 32 - 11 % 32);
         param1.writeInt(this.lootAmount << 13 % 32 | this.lootAmount >>> 32 - 13 % 32);
         param1.writeByte(this.nextLevelQualityRandomList.length);
         for each(_loc3_ in this.nextLevelQualityRandomList)
         {
            _loc3_.write(param1);
         }
         param1.writeInt(this.buildSeconds << 15 % 32 | this.buildSeconds >>> 32 - 15 % 32);
         param1.writeUTF(this.costLootId);
      }
   }
}

