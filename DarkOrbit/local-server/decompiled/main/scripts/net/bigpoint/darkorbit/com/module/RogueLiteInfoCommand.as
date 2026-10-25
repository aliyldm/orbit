package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class RogueLiteInfoCommand implements IModule
   {
      
      private static var _instance:RogueLiteInfoCommand;
      
      public var isAtGate:Boolean = false;
      
      public var cpuInfo:RogueLiteCpuInfoCommand;
      
      public var shipId:int = 0;
      
      public var score:int = 0;
      
      public var progress:int = 0;
      
      public var cashoutInfo:RogueLiteCashOutCommand;
      
      public var highscore:int = 0;
      
      public function RogueLiteInfoCommand(param1:int = 0, param2:int = 0, param3:int = 0, param4:int = 0, param5:Boolean = false, param6:RogueLiteCpuInfoCommand = null, param7:RogueLiteCashOutCommand = null)
      {
         super();
         this.isAtGate = param5;
         if(param6 == null)
         {
            this.cpuInfo = new RogueLiteCpuInfoCommand();
         }
         else
         {
            this.cpuInfo = param6;
         }
         this.shipId = param2;
         this.score = param3;
         this.progress = param1;
         if(param7 == null)
         {
            this.cashoutInfo = new RogueLiteCashOutCommand();
         }
         else
         {
            this.cashoutInfo = param7;
         }
         this.highscore = param4;
      }
      
      public static function get instance() : RogueLiteInfoCommand
      {
         return _instance || (_instance = new RogueLiteInfoCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -26562;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 17;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.isAtGate = param1.readBoolean();
         this.cpuInfo = RogueLiteCpuInfoCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.cpuInfo)
         {
            this.cpuInfo.read(param1);
         }
         this.shipId = param1.readInt();
         this.shipId = this.shipId >>> 2 % 32 | this.shipId << 32 - 2 % 32;
         this.score = param1.readInt();
         this.score = this.score << 2 % 32 | this.score >>> 32 - 2 % 32;
         this.progress = param1.readInt();
         this.progress = this.progress << 7 % 32 | this.progress >>> 32 - 7 % 32;
         this.cashoutInfo = RogueLiteCashOutCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.cashoutInfo)
         {
            this.cashoutInfo.read(param1);
         }
         this.highscore = param1.readInt();
         this.highscore = this.highscore >>> 4 % 32 | this.highscore << 32 - 4 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-26562);
         param1.writeBoolean(this.isAtGate);
         if(null != this.cpuInfo)
         {
            this.cpuInfo.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeInt(this.shipId << 2 % 32 | this.shipId >>> 32 - 2 % 32);
         param1.writeInt(this.score >>> 2 % 32 | this.score << 32 - 2 % 32);
         param1.writeInt(this.progress >>> 7 % 32 | this.progress << 32 - 7 % 32);
         if(null != this.cashoutInfo)
         {
            this.cashoutInfo.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeInt(this.highscore << 4 % 32 | this.highscore >>> 32 - 4 % 32);
      }
   }
}

