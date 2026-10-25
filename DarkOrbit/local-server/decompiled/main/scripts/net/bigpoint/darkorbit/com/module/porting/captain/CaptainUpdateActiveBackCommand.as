package net.bigpoint.darkorbit.com.module.porting.captain
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   import net.bigpoint.darkorbit.com.module.porting.messagestack.BaseStackCommand;
   
   public class CaptainUpdateActiveBackCommand implements IModule
   {
      
      private static var _instance:CaptainUpdateActiveBackCommand;
      
      public var result:Boolean = false;
      
      public var captainId:int = 0;
      
      public var errorId:BaseStackCommand;
      
      public function CaptainUpdateActiveBackCommand(param1:int = 0, param2:Boolean = false, param3:BaseStackCommand = null)
      {
         super();
         this.result = param2;
         this.captainId = param1;
         if(param3 == null)
         {
            this.errorId = new BaseStackCommand();
         }
         else
         {
            this.errorId = param3;
         }
      }
      
      public static function get instance() : CaptainUpdateActiveBackCommand
      {
         return _instance || (_instance = new CaptainUpdateActiveBackCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -17041;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 5;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.result = param1.readBoolean();
         this.captainId = param1.readInt();
         this.captainId = this.captainId << 14 % 32 | this.captainId >>> 32 - 14 % 32;
         this.errorId = BaseStackCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.errorId)
         {
            this.errorId.read(param1);
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-17041);
         param1.writeBoolean(this.result);
         param1.writeInt(this.captainId >>> 14 % 32 | this.captainId << 32 - 14 % 32);
         if(null != this.errorId)
         {
            this.errorId.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
      }
   }
}

