package net.bigpoint.darkorbit.com.module.porting.clan
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class CompanyDateInfoCommand implements IModule
   {
      
      private static var _instance:CompanyDateInfoCommand;
      
      public var members:Number = 0;
      
      public var ships:Number = 0;
      
      public var EP:Number = 0;
      
      public var aliens:Number = 0;
      
      public var hounr:Number = 0;
      
      public var ranking:Number = 0;
      
      public function CompanyDateInfoCommand(param1:Number = 0, param2:Number = 0, param3:Number = 0, param4:Number = 0, param5:Number = 0, param6:Number = 0)
      {
         super();
         this.members = param2;
         this.ships = param5;
         this.EP = param3;
         this.aliens = param6;
         this.hounr = param4;
         this.ranking = param1;
      }
      
      public static function get instance() : CompanyDateInfoCommand
      {
         return _instance || (_instance = new CompanyDateInfoCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -5978;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 48;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.members = param1.readDouble();
         this.ships = param1.readDouble();
         this.EP = param1.readDouble();
         this.aliens = param1.readDouble();
         this.hounr = param1.readDouble();
         this.ranking = param1.readDouble();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-5978);
         param1.writeDouble(this.members);
         param1.writeDouble(this.ships);
         param1.writeDouble(this.EP);
         param1.writeDouble(this.aliens);
         param1.writeDouble(this.hounr);
         param1.writeDouble(this.ranking);
      }
   }
}

