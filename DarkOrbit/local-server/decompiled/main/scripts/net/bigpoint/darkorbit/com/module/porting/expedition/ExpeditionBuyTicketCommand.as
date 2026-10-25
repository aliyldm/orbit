package net.bigpoint.darkorbit.com.module.porting.expedition
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   import net.bigpoint.darkorbit.com.module.porting.messagestack.BaseStackCommand;
   
   public class ExpeditionBuyTicketCommand implements IModule
   {
      
      private static var _instance:ExpeditionBuyTicketCommand;
      
      public var result:Boolean = false;
      
      public var stack:BaseStackCommand;
      
      public function ExpeditionBuyTicketCommand(param1:Boolean = false, param2:BaseStackCommand = null)
      {
         super();
         this.result = param1;
         if(param2 == null)
         {
            this.stack = new BaseStackCommand();
         }
         else
         {
            this.stack = param2;
         }
      }
      
      public static function get instance() : ExpeditionBuyTicketCommand
      {
         return _instance || (_instance = new ExpeditionBuyTicketCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 15621;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 1;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.result = param1.readBoolean();
         this.stack = BaseStackCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.stack)
         {
            this.stack.read(param1);
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(15621);
         param1.writeBoolean(this.result);
         if(null != this.stack)
         {
            this.stack.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
      }
   }
}

