package net.bigpoint.darkorbit.com.module.porting.hangar
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   import net.bigpoint.darkorbit.com.module.porting.messagestack.BaseStackCommand;
   
   public class HangarShipActivateShipCommand implements IModule
   {
      
      private static var _instance:HangarShipActivateShipCommand;
      
      public var errorMessage:BaseStackCommand;
      
      public var successMessage:BaseStackCommand;
      
      public var currentShipLootId:String = "";
      
      public var result:int = 0;
      
      public function HangarShipActivateShipCommand(param1:int = 0, param2:BaseStackCommand = null, param3:BaseStackCommand = null, param4:String = "")
      {
         super();
         if(param2 == null)
         {
            this.errorMessage = new BaseStackCommand();
         }
         else
         {
            this.errorMessage = param2;
         }
         if(param3 == null)
         {
            this.successMessage = new BaseStackCommand();
         }
         else
         {
            this.successMessage = param3;
         }
         this.currentShipLootId = param4;
         this.result = param1;
      }
      
      public static function get instance() : HangarShipActivateShipCommand
      {
         return _instance || (_instance = new HangarShipActivateShipCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 10529;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 6;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.errorMessage = BaseStackCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.errorMessage)
         {
            this.errorMessage.read(param1);
         }
         this.successMessage = BaseStackCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.successMessage)
         {
            this.successMessage.read(param1);
         }
         this.currentShipLootId = param1.readUTF();
         this.result = param1.readInt();
         this.result = this.result << 10 % 32 | this.result >>> 32 - 10 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(10529);
         if(null != this.errorMessage)
         {
            this.errorMessage.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         if(null != this.successMessage)
         {
            this.successMessage.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeUTF(this.currentShipLootId);
         param1.writeInt(this.result >>> 10 % 32 | this.result << 32 - 10 % 32);
      }
   }
}

