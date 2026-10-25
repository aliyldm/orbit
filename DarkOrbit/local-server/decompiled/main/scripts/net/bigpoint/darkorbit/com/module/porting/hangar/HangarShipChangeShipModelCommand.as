package net.bigpoint.darkorbit.com.module.porting.hangar
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   import net.bigpoint.darkorbit.com.module.porting.messagestack.BaseStackCommand;
   
   public class HangarShipChangeShipModelCommand implements IModule
   {
      
      private static var _instance:HangarShipChangeShipModelCommand;
      
      public var resultId:int = 0;
      
      public var errorMessage:BaseStackCommand;
      
      public function HangarShipChangeShipModelCommand(param1:int = 0, param2:BaseStackCommand = null)
      {
         super();
         this.resultId = param1;
         if(param2 == null)
         {
            this.errorMessage = new BaseStackCommand();
         }
         else
         {
            this.errorMessage = param2;
         }
      }
      
      public static function get instance() : HangarShipChangeShipModelCommand
      {
         return _instance || (_instance = new HangarShipChangeShipModelCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 20520;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.resultId = param1.readInt();
         this.resultId = this.resultId >>> 2 % 32 | this.resultId << 32 - 2 % 32;
         this.errorMessage = BaseStackCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.errorMessage)
         {
            this.errorMessage.read(param1);
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(20520);
         param1.writeInt(this.resultId << 2 % 32 | this.resultId >>> 32 - 2 % 32);
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

