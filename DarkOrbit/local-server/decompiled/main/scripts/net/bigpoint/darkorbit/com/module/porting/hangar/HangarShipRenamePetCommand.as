package net.bigpoint.darkorbit.com.module.porting.hangar
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   import net.bigpoint.darkorbit.com.module.porting.messagestack.BaseStackCommand;
   
   public class HangarShipRenamePetCommand implements IModule
   {
      
      private static var _instance:HangarShipRenamePetCommand;
      
      public var errorMessage:BaseStackCommand;
      
      public var resultId:int = 0;
      
      public var newName:String = "";
      
      public function HangarShipRenamePetCommand(param1:int = 0, param2:BaseStackCommand = null, param3:String = "")
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
         this.resultId = param1;
         this.newName = param3;
      }
      
      public static function get instance() : HangarShipRenamePetCommand
      {
         return _instance || (_instance = new HangarShipRenamePetCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 4334;
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
         this.resultId = param1.readInt();
         this.resultId = this.resultId >>> 14 % 32 | this.resultId << 32 - 14 % 32;
         this.newName = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(4334);
         if(null != this.errorMessage)
         {
            this.errorMessage.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeInt(this.resultId << 14 % 32 | this.resultId >>> 32 - 14 % 32);
         param1.writeUTF(this.newName);
      }
   }
}

