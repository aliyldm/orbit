package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class EternalGateInfoCommand implements IModule
   {
      
      private static var _instance:EternalGateInfoCommand;
      
      public var playerRankRanges:Vector.<RankRewardRangeModule>;
      
      public var boosterInfoCommand:EternalGateBoosterInfoCommand;
      
      public var keyInfo:EternalGateKeyInfoCommand;
      
      public var waveInfo:EternalGateWaveInfoCommand;
      
      public var rankInfoCommand:EternalGateRankInfoCommand;
      
      public function EternalGateInfoCommand(param1:EternalGateWaveInfoCommand = null, param2:EternalGateKeyInfoCommand = null, param3:Vector.<RankRewardRangeModule> = null, param4:EternalGateBoosterInfoCommand = null, param5:EternalGateRankInfoCommand = null)
      {
         super();
         if(param3 == null)
         {
            this.playerRankRanges = new Vector.<RankRewardRangeModule>();
         }
         else
         {
            this.playerRankRanges = param3;
         }
         if(param4 == null)
         {
            this.boosterInfoCommand = new EternalGateBoosterInfoCommand();
         }
         else
         {
            this.boosterInfoCommand = param4;
         }
         if(param2 == null)
         {
            this.keyInfo = new EternalGateKeyInfoCommand();
         }
         else
         {
            this.keyInfo = param2;
         }
         if(param1 == null)
         {
            this.waveInfo = new EternalGateWaveInfoCommand();
         }
         else
         {
            this.waveInfo = param1;
         }
         if(param5 == null)
         {
            this.rankInfoCommand = new EternalGateRankInfoCommand();
         }
         else
         {
            this.rankInfoCommand = param5;
         }
      }
      
      public static function get instance() : EternalGateInfoCommand
      {
         return _instance || (_instance = new EternalGateInfoCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 24808;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:RankRewardRangeModule = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.playerRankRanges.length > 0)
         {
            this.playerRankRanges.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = RankRewardRangeModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.playerRankRanges.push(_loc4_);
            _loc2_++;
         }
         this.boosterInfoCommand = EternalGateBoosterInfoCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.boosterInfoCommand)
         {
            this.boosterInfoCommand.read(param1);
         }
         this.keyInfo = EternalGateKeyInfoCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.keyInfo)
         {
            this.keyInfo.read(param1);
         }
         this.waveInfo = EternalGateWaveInfoCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.waveInfo)
         {
            this.waveInfo.read(param1);
         }
         this.rankInfoCommand = EternalGateRankInfoCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.rankInfoCommand)
         {
            this.rankInfoCommand.read(param1);
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:RankRewardRangeModule = null;
         param1.writeShort(24808);
         param1.writeByte(this.playerRankRanges.length);
         for each(_loc2_ in this.playerRankRanges)
         {
            _loc2_.write(param1);
         }
         if(null != this.boosterInfoCommand)
         {
            this.boosterInfoCommand.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         if(null != this.keyInfo)
         {
            this.keyInfo.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         if(null != this.waveInfo)
         {
            this.waveInfo.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         if(null != this.rankInfoCommand)
         {
            this.rankInfoCommand.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
      }
   }
}

