package net.bigpoint.darkorbit.com.module.porting.userMessage
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   import net.bigpoint.darkorbit.com.module.porting.messagestack.BaseStackCommand;
   
   public class ContactListBlockInvitationsTipsCommand implements IModule
   {
      
      private static var _instance:ContactListBlockInvitationsTipsCommand;
      
      public var text:BaseStackCommand;
      
      public var title:BaseStackCommand;
      
      public function ContactListBlockInvitationsTipsCommand(param1:BaseStackCommand = null, param2:BaseStackCommand = null)
      {
         super();
         if(param2 == null)
         {
            this.text = new BaseStackCommand();
         }
         else
         {
            this.text = param2;
         }
         if(param1 == null)
         {
            this.title = new BaseStackCommand();
         }
         else
         {
            this.title = param1;
         }
      }
      
      public static function get instance() : ContactListBlockInvitationsTipsCommand
      {
         return _instance || (_instance = new ContactListBlockInvitationsTipsCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -29213;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 0;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.text = BaseStackCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.text)
         {
            this.text.read(param1);
         }
         this.title = BaseStackCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.title)
         {
            this.title.read(param1);
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-29213);
         if(null != this.text)
         {
            this.text.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         if(null != this.title)
         {
            this.title.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
      }
   }
}

