package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   public class ContactListEntryAttributeClanRelationModule extends ContactListEntryAttributeBaseModule
   {
      
      private static var _instance:ContactListEntryAttributeClanRelationModule;
      
      public var clanRelation:ClanRelationModule;
      
      public function ContactListEntryAttributeClanRelationModule(param1:ClanRelationModule = null)
      {
         super();
         if(param1 == null)
         {
            this.clanRelation = new ClanRelationModule();
         }
         else
         {
            this.clanRelation = param1;
         }
      }
      
      public static function get instance() : ContactListEntryAttributeClanRelationModule
      {
         return _instance || (_instance = new ContactListEntryAttributeClanRelationModule());
      }
      
      override public function getLibcomModuleId() : int
      {
         return 16647;
      }
      
      override public function getLibcomModuleEstimatedLength() : int
      {
         return 0;
      }
      
      override public function read(param1:IDataInput) : void
      {
         param1.readShort();
         super.read(param1);
         this.clanRelation = ClanRelationModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.clanRelation)
         {
            this.clanRelation.read(param1);
         }
      }
      
      override public function write(param1:IDataOutput) : void
      {
         param1.writeShort(16647);
         super.write(param1);
         if(null != this.clanRelation)
         {
            this.clanRelation.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
      }
   }
}

