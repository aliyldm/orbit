package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class GalaxyGateBuilderBuyLifeCommand implements IModule
   {
      
      private static var _instance:GalaxyGateBuilderBuyLifeCommand;
      
      public static const ERRORCODE_NONE:int = 0;
      
      public static const ERRORCODE_NOT_ENOUGH_MONEY:int = 1;
      
      public static const ERRORCODE_UNCLASSIFIED_ERROR:int = 2;
      
      public static const ERRORCODE__MAX:int = 3;
      
      public var samples:Number = 0;
      
      public var multiplier:int = 0;
      
      public var gateId:int = 0;
      
      public var errorCode:int = 0;
      
      public var lifePrice:int = 0;
      
      public var money:Number = 0;
      
      public var gateMode:String = "";
      
      public var livesLeft:int = 0;
      
      public function GalaxyGateBuilderBuyLifeCommand(param1:String = "", param2:int = 0, param3:Number = 0, param4:Number = 0, param5:int = 0, param6:int = 0, param7:int = 0, param8:int = 0)
      {
         super();
         this.samples = param4;
         this.multiplier = param5;
         this.gateId = param2;
         this.errorCode = param8;
         this.lifePrice = param7;
         this.money = param3;
         this.gateMode = param1;
         this.livesLeft = param6;
      }
      
      public static function get instance() : GalaxyGateBuilderBuyLifeCommand
      {
         return _instance || (_instance = new GalaxyGateBuilderBuyLifeCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 31119;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 28;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.samples = param1.readDouble();
         this.multiplier = param1.readByte();
         this.multiplier = 0xFF & ((0xFF & this.multiplier) << 16 % 8 | (0xFF & this.multiplier) >>> 8 - 16 % 8);
         this.multiplier = this.multiplier > 127 ? int(this.multiplier - 256) : this.multiplier;
         this.gateId = param1.readByte();
         this.gateId = 0xFF & ((0xFF & this.gateId) << 9 % 8 | (0xFF & this.gateId) >>> 8 - 9 % 8);
         this.gateId = this.gateId > 127 ? int(this.gateId - 256) : this.gateId;
         this.errorCode = param1.readShort();
         this.lifePrice = param1.readInt();
         this.lifePrice = this.lifePrice << 9 % 32 | this.lifePrice >>> 32 - 9 % 32;
         this.money = param1.readDouble();
         this.gateMode = param1.readUTF();
         this.livesLeft = param1.readInt();
         this.livesLeft = this.livesLeft >>> 16 % 32 | this.livesLeft << 32 - 16 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(31119);
         param1.writeDouble(this.samples);
         param1.writeByte(0xFF & ((0xFF & this.multiplier) >>> 16 % 8 | (0xFF & this.multiplier) << 8 - 16 % 8));
         param1.writeByte(0xFF & ((0xFF & this.gateId) >>> 9 % 8 | (0xFF & this.gateId) << 8 - 9 % 8));
         param1.writeShort(this.errorCode);
         param1.writeInt(this.lifePrice >>> 9 % 32 | this.lifePrice << 32 - 9 % 32);
         param1.writeDouble(this.money);
         param1.writeUTF(this.gateMode);
         param1.writeInt(this.livesLeft << 16 % 32 | this.livesLeft >>> 32 - 16 % 32);
      }
   }
}

