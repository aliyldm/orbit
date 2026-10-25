package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class GalaxyGateBuilderSetupGateCommand implements IModule
   {
      
      private static var _instance:GalaxyGateBuilderSetupGateCommand;
      
      public static const ERRORCODE_NONE:int = 0;
      
      public static const ERRORCODE_UNCLASSIFIED_ERROR:int = 1;
      
      public static const ERRORCODE__MAX:int = 2;
      
      public var livesLeft:int = 0;
      
      public var lifePrice:int = 0;
      
      public var id:int = 0;
      
      public var errorCode:int = 0;
      
      public function GalaxyGateBuilderSetupGateCommand(param1:int = 0, param2:int = 0, param3:int = 0, param4:int = 0)
      {
         super();
         this.livesLeft = param2;
         this.lifePrice = param3;
         this.id = param1;
         this.errorCode = param4;
      }
      
      public static function get instance() : GalaxyGateBuilderSetupGateCommand
      {
         return _instance || (_instance = new GalaxyGateBuilderSetupGateCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -10753;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 9;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.livesLeft = param1.readInt();
         this.livesLeft = this.livesLeft << 15 % 32 | this.livesLeft >>> 32 - 15 % 32;
         this.lifePrice = param1.readInt();
         this.lifePrice = this.lifePrice << 15 % 32 | this.lifePrice >>> 32 - 15 % 32;
         this.id = param1.readByte();
         this.id = 0xFF & ((0xFF & this.id) << 8 % 8 | (0xFF & this.id) >>> 8 - 8 % 8);
         this.id = this.id > 127 ? int(this.id - 256) : this.id;
         this.errorCode = param1.readShort();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-10753);
         param1.writeInt(this.livesLeft >>> 15 % 32 | this.livesLeft << 32 - 15 % 32);
         param1.writeInt(this.lifePrice >>> 15 % 32 | this.lifePrice << 32 - 15 % 32);
         param1.writeByte(0xFF & ((0xFF & this.id) >>> 8 % 8 | (0xFF & this.id) << 8 - 8 % 8));
         param1.writeShort(this.errorCode);
      }
   }
}

