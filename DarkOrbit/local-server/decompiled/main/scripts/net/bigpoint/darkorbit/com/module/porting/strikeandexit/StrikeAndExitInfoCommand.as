package net.bigpoint.darkorbit.com.module.porting.strikeandexit
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class StrikeAndExitInfoCommand implements IModule
   {
      
      private static var _instance:StrikeAndExitInfoCommand;
      
      public var currentGetStellarCoin:int = 0;
      
      public var vip:Boolean = false;
      
      public var nextOpenSeconds:int = 0;
      
      public var inDouble:Boolean = false;
      
      public var StellarCoinLimit:int = 0;
      
      public var inSession:Boolean = false;
      
      public function StrikeAndExitInfoCommand(param1:Boolean = false, param2:int = 0, param3:int = 0, param4:int = 0, param5:Boolean = false, param6:Boolean = false)
      {
         super();
         this.currentGetStellarCoin = param4;
         this.vip = param6;
         this.nextOpenSeconds = param2;
         this.inDouble = param5;
         this.StellarCoinLimit = param3;
         this.inSession = param1;
      }
      
      public static function get instance() : StrikeAndExitInfoCommand
      {
         return _instance || (_instance = new StrikeAndExitInfoCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -17332;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 15;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.currentGetStellarCoin = param1.readInt();
         this.currentGetStellarCoin = this.currentGetStellarCoin << 3 % 32 | this.currentGetStellarCoin >>> 32 - 3 % 32;
         this.vip = param1.readBoolean();
         this.nextOpenSeconds = param1.readInt();
         this.nextOpenSeconds = this.nextOpenSeconds >>> 8 % 32 | this.nextOpenSeconds << 32 - 8 % 32;
         this.inDouble = param1.readBoolean();
         this.StellarCoinLimit = param1.readInt();
         this.StellarCoinLimit = this.StellarCoinLimit << 1 % 32 | this.StellarCoinLimit >>> 32 - 1 % 32;
         this.inSession = param1.readBoolean();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-17332);
         param1.writeInt(this.currentGetStellarCoin >>> 3 % 32 | this.currentGetStellarCoin << 32 - 3 % 32);
         param1.writeBoolean(this.vip);
         param1.writeInt(this.nextOpenSeconds << 8 % 32 | this.nextOpenSeconds >>> 32 - 8 % 32);
         param1.writeBoolean(this.inDouble);
         param1.writeInt(this.StellarCoinLimit >>> 1 % 32 | this.StellarCoinLimit << 32 - 1 % 32);
         param1.writeBoolean(this.inSession);
      }
   }
}

