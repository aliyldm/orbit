package net.bigpoint.darkorbit.com.module.porting.clan
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   
   public class LoginInitClanCommand implements IModule
   {
      
      private static var _instance:LoginInitClanCommand;
      
      public var clanAllInfoCommand:ClanAllInfoCommand;
      
      public function LoginInitClanCommand(param1:ClanAllInfoCommand = null)
      {
         super();
         if(param1 == null)
         {
            this.clanAllInfoCommand = new ClanAllInfoCommand();
         }
         else
         {
            this.clanAllInfoCommand = param1;
         }
      }
      
      public static function get instance() : LoginInitClanCommand
      {
         return _instance || (_instance = new LoginInitClanCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -31515;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 0;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.clanAllInfoCommand = ClanAllInfoCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.clanAllInfoCommand)
         {
            this.clanAllInfoCommand.read(param1);
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-31515);
         if(null != this.clanAllInfoCommand)
         {
            this.clanAllInfoCommand.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
      }
   }
}

