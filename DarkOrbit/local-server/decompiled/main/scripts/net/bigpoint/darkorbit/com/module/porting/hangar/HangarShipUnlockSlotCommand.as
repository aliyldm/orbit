package net.bigpoint.darkorbit.com.module.porting.hangar
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   import net.bigpoint.darkorbit.com.module.porting.messagestack.BaseStackCommand;
   
   public class HangarShipUnlockSlotCommand implements IModule
   {
      
      private static var _instance:HangarShipUnlockSlotCommand;
      
      public var nextGearsSlotUridium:int = 0;
      
      public var nextLasersSlotUridium:int = 0;
      
      public var errorMessage:BaseStackCommand;
      
      public var nextGeneratorSlotUridium:int = 0;
      
      public var nextProtocolsSlotUridium:int = 0;
      
      public var nextHeatSlotUridium:int = 0;
      
      public var resultId:int = 0;
      
      public function HangarShipUnlockSlotCommand(param1:int = 0, param2:BaseStackCommand = null, param3:int = 0, param4:int = 0, param5:int = 0, param6:int = 0, param7:int = 0)
      {
         super();
         this.nextGearsSlotUridium = param7;
         this.nextLasersSlotUridium = param3;
         if(param2 == null)
         {
            this.errorMessage = new BaseStackCommand();
         }
         else
         {
            this.errorMessage = param2;
         }
         this.nextGeneratorSlotUridium = param4;
         this.nextProtocolsSlotUridium = param5;
         this.nextHeatSlotUridium = param6;
         this.resultId = param1;
      }
      
      public static function get instance() : HangarShipUnlockSlotCommand
      {
         return _instance || (_instance = new HangarShipUnlockSlotCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -1848;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 24;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.nextGearsSlotUridium = param1.readInt();
         this.nextGearsSlotUridium = this.nextGearsSlotUridium >>> 6 % 32 | this.nextGearsSlotUridium << 32 - 6 % 32;
         this.nextLasersSlotUridium = param1.readInt();
         this.nextLasersSlotUridium = this.nextLasersSlotUridium << 1 % 32 | this.nextLasersSlotUridium >>> 32 - 1 % 32;
         this.errorMessage = BaseStackCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.errorMessage)
         {
            this.errorMessage.read(param1);
         }
         this.nextGeneratorSlotUridium = param1.readInt();
         this.nextGeneratorSlotUridium = this.nextGeneratorSlotUridium << 1 % 32 | this.nextGeneratorSlotUridium >>> 32 - 1 % 32;
         this.nextProtocolsSlotUridium = param1.readInt();
         this.nextProtocolsSlotUridium = this.nextProtocolsSlotUridium >>> 8 % 32 | this.nextProtocolsSlotUridium << 32 - 8 % 32;
         this.nextHeatSlotUridium = param1.readInt();
         this.nextHeatSlotUridium = this.nextHeatSlotUridium << 5 % 32 | this.nextHeatSlotUridium >>> 32 - 5 % 32;
         this.resultId = param1.readInt();
         this.resultId = this.resultId >>> 2 % 32 | this.resultId << 32 - 2 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-1848);
         param1.writeInt(this.nextGearsSlotUridium << 6 % 32 | this.nextGearsSlotUridium >>> 32 - 6 % 32);
         param1.writeInt(this.nextLasersSlotUridium >>> 1 % 32 | this.nextLasersSlotUridium << 32 - 1 % 32);
         if(null != this.errorMessage)
         {
            this.errorMessage.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeInt(this.nextGeneratorSlotUridium >>> 1 % 32 | this.nextGeneratorSlotUridium << 32 - 1 % 32);
         param1.writeInt(this.nextProtocolsSlotUridium << 8 % 32 | this.nextProtocolsSlotUridium >>> 32 - 8 % 32);
         param1.writeInt(this.nextHeatSlotUridium >>> 5 % 32 | this.nextHeatSlotUridium << 32 - 5 % 32);
         param1.writeInt(this.resultId << 2 % 32 | this.resultId >>> 32 - 2 % 32);
      }
   }
}

