package net.bigpoint.darkorbit.com.module.porting.clan
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   import net.bigpoint.darkorbit.com.module.porting.messagestack.BaseStackCommand;
   
   public class ClanEditDiploOfferCommand implements IModule
   {
      
      private static var _instance:ClanEditDiploOfferCommand;
      
      public var status:String = "";
      
      public var success:Boolean = false;
      
      public var clanDiploInfoCommand:ClanDiploInfoCommand;
      
      public var stack:BaseStackCommand;
      
      public var clanDiploReqInfoCommand:ClanDiploReqInfoCommand;
      
      public function ClanEditDiploOfferCommand(param1:Boolean = false, param2:BaseStackCommand = null, param3:ClanDiploReqInfoCommand = null, param4:ClanDiploInfoCommand = null, param5:String = "")
      {
         super();
         this.status = param5;
         this.success = param1;
         if(param4 == null)
         {
            this.clanDiploInfoCommand = new ClanDiploInfoCommand();
         }
         else
         {
            this.clanDiploInfoCommand = param4;
         }
         if(param2 == null)
         {
            this.stack = new BaseStackCommand();
         }
         else
         {
            this.stack = param2;
         }
         if(param3 == null)
         {
            this.clanDiploReqInfoCommand = new ClanDiploReqInfoCommand();
         }
         else
         {
            this.clanDiploReqInfoCommand = param3;
         }
      }
      
      public static function get instance() : ClanEditDiploOfferCommand
      {
         return _instance || (_instance = new ClanEditDiploOfferCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -27877;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 3;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.status = param1.readUTF();
         this.success = param1.readBoolean();
         this.clanDiploInfoCommand = ClanDiploInfoCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.clanDiploInfoCommand)
         {
            this.clanDiploInfoCommand.read(param1);
         }
         this.stack = BaseStackCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.stack)
         {
            this.stack.read(param1);
         }
         this.clanDiploReqInfoCommand = ClanDiploReqInfoCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.clanDiploReqInfoCommand)
         {
            this.clanDiploReqInfoCommand.read(param1);
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-27877);
         param1.writeUTF(this.status);
         param1.writeBoolean(this.success);
         if(null != this.clanDiploInfoCommand)
         {
            this.clanDiploInfoCommand.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         if(null != this.stack)
         {
            this.stack.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         if(null != this.clanDiploReqInfoCommand)
         {
            this.clanDiploReqInfoCommand.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
      }
   }
}

