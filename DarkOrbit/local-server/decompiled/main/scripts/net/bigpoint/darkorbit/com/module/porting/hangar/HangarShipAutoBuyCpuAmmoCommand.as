package net.bigpoint.darkorbit.com.module.porting.hangar
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   import net.bigpoint.darkorbit.com.module.porting.messagestack.BaseStackCommand;
   
   public class HangarShipAutoBuyCpuAmmoCommand implements IModule
   {
      
      private static var _instance:HangarShipAutoBuyCpuAmmoCommand;
      
      public var result:int = 0;
      
      public var cpuItemId:Number = 0;
      
      public var ammoLootId:String = "";
      
      public var errorMessage:BaseStackCommand;
      
      public function HangarShipAutoBuyCpuAmmoCommand(param1:int = 0, param2:BaseStackCommand = null, param3:Number = 0, param4:String = "")
      {
         super();
         this.result = param1;
         this.cpuItemId = param3;
         this.ammoLootId = param4;
         if(param2 == null)
         {
            this.errorMessage = new BaseStackCommand();
         }
         else
         {
            this.errorMessage = param2;
         }
      }
      
      public static function get instance() : HangarShipAutoBuyCpuAmmoCommand
      {
         return _instance || (_instance = new HangarShipAutoBuyCpuAmmoCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 2891;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 14;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.result = param1.readInt();
         this.result = this.result << 5 % 32 | this.result >>> 32 - 5 % 32;
         this.cpuItemId = param1.readDouble();
         this.ammoLootId = param1.readUTF();
         this.errorMessage = BaseStackCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.errorMessage)
         {
            this.errorMessage.read(param1);
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(2891);
         param1.writeInt(this.result >>> 5 % 32 | this.result << 32 - 5 % 32);
         param1.writeDouble(this.cpuItemId);
         param1.writeUTF(this.ammoLootId);
         if(null != this.errorMessage)
         {
            this.errorMessage.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
      }
   }
}

