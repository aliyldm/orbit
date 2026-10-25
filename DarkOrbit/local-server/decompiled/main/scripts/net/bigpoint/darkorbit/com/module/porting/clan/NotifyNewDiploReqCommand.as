package net.bigpoint.darkorbit.com.module.porting.clan
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   
   public class NotifyNewDiploReqCommand implements IModule
   {
      
      private static var _instance:NotifyNewDiploReqCommand;
      
      public var command:ClanDiploInfoCommand;
      
      public function NotifyNewDiploReqCommand(param1:ClanDiploInfoCommand = null)
      {
         super();
         if(param1 == null)
         {
            this.command = new ClanDiploInfoCommand();
         }
         else
         {
            this.command = param1;
         }
      }
      
      public static function get instance() : NotifyNewDiploReqCommand
      {
         return _instance || (_instance = new NotifyNewDiploReqCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -29387;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 0;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.command = ClanDiploInfoCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.command)
         {
            this.command.read(param1);
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-29387);
         if(null != this.command)
         {
            this.command.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
      }
   }
}

