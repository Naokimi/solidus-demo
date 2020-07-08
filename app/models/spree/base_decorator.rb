module Spree::BaseDecorator
  def self.prepended(base)
    base.class_eval do
      before_create :set_token
      before_update :verify_token
      default_scope { where(sample_indicator_id: [nil, Current.token].uniq) }

      # Set the sample data attributes to equal the changed data
      after_find do |user|
        changeable = find_changeable
        self.attributes = changeable.changed_data if changeable
      end
    end
  end

  def set_token
    self.sample_indicator_id = Current.token
  end

  def verify_token
    apply_changes_to_changeable unless sample_indicator_id?
  end

  def destroy!
    super if sample_indicator_id?
  end

  private

  # Apply changes to the changeable object instead of the sample object
  def apply_changes_to_changeable
    if changes.any?
      changeable = find_changeable || Spree::SampleChanges.new(changeable_type: self.class.name, changeable_id: id)
      changeable.changed_data = attributes
      # This method on Stores does not play well with this ActiveRecord hackery
      changeable.changed_data.delete("available_locales")
      changeable.save
      # Mark changes as already applied so the original object is unaffected
      changes_applied
    end
  end

  def find_changeable
    Spree::SampleChanges.find_by(changeable_type: self.class.name, changeable_id: id)
  end

end

Spree::Base.prepend Spree::BaseDecorator
# [:state_ids, :country_ids, :include?, :country_list, :zoneables, :country_ids=, :state_ids=, :autosave_associated_records_for_zone_members, :validate_associated_records_for_zone_members, :before_add_for_zone_members, :before_add_for_zone_members?, :before_add_for_zone_members=, :after_add_for_zone_members, :after_add_for_zone_members?, :after_add_for_zone_members=, :before_remove_for_zone_members, :before_remove_for_zone_members?, :before_remove_for_zone_members=, :after_remove_for_zone_members, :after_remove_for_zone_members?, :after_remove_for_zone_members=, :autosave_associated_records_for_tax_rates, :validate_associated_records_for_tax_rates, :before_add_for_tax_rates, :before_add_for_tax_rates?, :before_add_for_tax_rates=, :after_add_for_tax_rates, :after_add_for_tax_rates?, :after_add_for_tax_rates=, :before_remove_for_tax_rates, :before_remove_for_tax_rates?, :before_remove_for_tax_rates=, :after_remove_for_tax_rates, :after_remove_for_tax_rates?, :after_remove_for_tax_rates=, :autosave_associated_records_for_countries, :validate_associated_records_for_countries, :before_add_for_countries, :before_add_for_countries?, :before_add_for_countries=, :after_add_for_countries, :after_add_for_countries?, :after_add_for_countries=, :before_remove_for_countries, :before_remove_for_countries?, :before_remove_for_countries=, :after_remove_for_countries, :after_remove_for_countries?, :after_remove_for_countries=, :autosave_associated_records_for_states, :validate_associated_records_for_states, :before_add_for_states, :before_add_for_states?, :before_add_for_states=, :after_add_for_states, :after_add_for_states?, :after_add_for_states=, :before_remove_for_states, :before_remove_for_states?, :before_remove_for_states=, :after_remove_for_states, :after_remove_for_states?, :after_remove_for_states=, :kind, :autosave_associated_records_for_shipping_method_zones, :validate_associated_records_for_shipping_method_zones, :before_add_for_shipping_method_zones, :before_add_for_shipping_method_zones?, :before_add_for_shipping_method_zones=, :after_add_for_shipping_method_zones, :after_add_for_shipping_method_zones?, :after_add_for_shipping_method_zones=, :before_remove_for_shipping_method_zones, :before_remove_for_shipping_method_zones?, :before_remove_for_shipping_method_zones=, :after_remove_for_shipping_method_zones, :after_remove_for_shipping_method_zones?, :after_remove_for_shipping_method_zones=, :autosave_associated_records_for_shipping_methods, :validate_associated_records_for_shipping_methods, :before_add_for_shipping_methods, :before_add_for_shipping_methods?, :before_add_for_shipping_methods=, :after_add_for_shipping_methods, :after_add_for_shipping_methods?, :after_add_for_shipping_methods=, :before_remove_for_shipping_methods, :before_remove_for_shipping_methods?, :before_remove_for_shipping_methods=, :after_remove_for_shipping_methods, :after_remove_for_shipping_methods?, :after_remove_for_shipping_methods=, :members, :<=>, :kind=, :shipping_method_zones, :shipping_methods, :tax_rates, :countries, :shipping_methods=, :tax_rates=, :shipping_method_zone_ids, :shipping_method_zones=, :shipping_method_zone_ids=, :zone_member_ids, :zone_members=, :zone_member_ids=, :states=, :shipping_method_ids, :shipping_method_ids=, :tax_rate_ids, :tax_rate_ids=, :zone_members, :zone_members_attributes=, :countries=, :states, :description, :will_save_change_to_updated_at?, :updated_at_previous_change, :restore_updated_at!, :updated_at_before_last_save, :sample_indicator_id?, :name, :created_at=, :updated_at=, :updated_at_before_type_cast, :updated_at_came_from_user?, :name?, :sample_indicator_id, :sample_indicator_id_before_type_cast, :sample_indicator_id_came_from_user?, :sample_indicator_id_changed?, :sample_indicator_id_change, :sample_indicator_id_will_change!, :sample_indicator_id_was, :sample_indicator_id_previously_changed?, :sample_indicator_id_previous_change, :restore_sample_indicator_id!, :saved_change_to_sample_indicator_id?, :saved_change_to_sample_indicator_id, :sample_indicator_id_before_last_save, :will_save_change_to_sample_indicator_id?, :sample_indicator_id_change_to_be_saved, :sample_indicator_id_in_database, :id_came_from_user?, :id_changed?, :id_change, :id_will_change!, :id_previously_changed?, :id_previous_change, :restore_id!, :saved_change_to_id?, :saved_change_to_id, :id_before_last_save, :will_save_change_to_id?, :id_change_to_be_saved, :created_at_before_type_cast, :created_at_came_from_user?, :description=, :created_at?, :created_at_changed?, :created_at_change, :created_at_will_change!, :created_at_was, :created_at_previously_changed?, :created_at_previous_change, :restore_created_at!, :saved_change_to_created_at?, :saved_change_to_created_at, :created_at_before_last_save, :will_save_change_to_created_at?, :created_at_change_to_be_saved, :created_at_in_database, :updated_at?, :updated_at_changed?, :updated_at_change, :updated_at_will_change!, :updated_at_was, :name=, :name_before_type_cast, :name_came_from_user?, :name_changed?, :name_change, :name_will_change!, :name_was, :name_previously_changed?, :name_previous_change, :restore_name!, :saved_change_to_name?, :saved_change_to_name, :name_before_last_save, :will_save_change_to_name?, :name_change_to_be_saved, :description_will_change!, :name_in_database, :description_change, :description_came_from_user?, :description_was, :description_changed?, :description_previous_change, :description_before_type_cast, :saved_change_to_description?, :description?, :description_before_last_save, :restore_description!, :description_change_to_be_saved, :zone_members_count_before_type_cast, :description_previously_changed?, :will_save_change_to_description?, :zone_members_count_will_change!, :description_in_database, :saved_change_to_description, :zone_members_count=, :zone_members_count_change, :zone_members_count_came_from_user?, :zone_members_count?, :zone_members_count, :zone_members_count_previous_change, :restore_zone_members_count!, :zone_members_count_was, :zone_members_count_previously_changed?, :zone_members_count_changed?, :will_save_change_to_zone_members_count?, :saved_change_to_zone_members_count?, :saved_change_to_zone_members_count, :zone_members_count_before_last_save, :saved_change_to_updated_at, :zone_members_count_change_to_be_saved, :zone_members_count_in_database, :updated_at_change_to_be_saved, :updated_at_in_database, :sample_indicator_id=, :updated_at_previously_changed?, :created_at, :updated_at, :saved_change_to_updated_at?, :set_token, :verify_token, :default_ransackable_attributes=, :whitelisted_ransackable_associations, :whitelisted_ransackable_attributes, :default_ransackable_attributes, :whitelisted_ransackable_associations?, :whitelisted_ransackable_associations=, :whitelisted_ransackable_attributes?, :whitelisted_ransackable_attributes=, :default_ransackable_attributes?, :initialize_preference_defaults, :get_preference, :set_preference, :has_preference!, :preference_type, :preference_default, :has_preference?, :defined_preferences, :default_preferences, :admin_form_preference_names, :default_timezone, :_ransackers, :default_connection_handler?, :nested_attributes_options, :default_scopes, :_ransackers?, :_ransack_aliases?, :permalink_options?, :column_for_attribute, :cache_timestamp_format, :collection_cache_versioning, :nested_attributes_options?, :attachment_reflections?, :schema_format, :cache_timestamp_format?, :cache_versioning?, :collection_cache_versioning?, :table_name_prefix, :_validate_callbacks, :table_name_suffix, :_validators?, :attribute_method_matchers, :_run_before_commit_callbacks, :_run_before_commit_without_transaction_enrollment_callbacks, :_run_commit_without_transaction_enrollment_callbacks, :attribute_aliases, :_run_commit_callbacks, :lock_optimistically, :_run_rollback_callbacks, :_run_rollback_without_transaction_enrollment_callbacks, :lock_optimistically?, :_validation_callbacks, :_initialize_callbacks, :_rollback_callbacks, :_find_callbacks, :_before_commit_callbacks, :_commit_callbacks, :_run_touch_callbacks, :_touch_callbacks, :timestamped_migrations, :_run_save_callbacks, :_save_callbacks, :_before_commit_without_transaction_enrollment_callbacks, :_run_create_callbacks, :_create_callbacks, :cache_versioning, :_commit_without_transaction_enrollment_callbacks, :_run_update_callbacks, :_update_callbacks, :_ransack_aliases, :_rollback_without_transaction_enrollment_callbacks, :_run_destroy_callbacks, :_destroy_callbacks, :attribute_aliases?, :attribute_method_matchers?, :warn_on_records_fetched_greater_than, :aggregate_reflections?, :_reflections?, :include_root_in_json, :permalink_options, :permalink_options=, :default_connection_handler, :include_root_in_json?, :time_zone_aware_attributes, :skip_time_zone_conversion_for_attributes, :time_zone_aware_types, :paranoid?, :__callbacks, :skip_time_zone_conversion_for_attributes?, :validation_context, :_validators, :partial_writes, :time_zone_aware_types?, :_run_validate_callbacks, :verbose_query_logs, :partial_writes?, :defined_enums, :record_timestamps, :_ransackers=, :primary_key_prefix_type, :_ransack_aliases=, :attachment_reflections, :defined_enums?, :_reflections, :aggregate_reflections, :error_on_ignored_order, :allow_unsafe_raw_sql, :dump_schema_after_migration, :dump_schemas, :pluralize_table_names, :record_timestamps?, :record_timestamps=, :_run_validation_callbacks, :index_nested_attribute_errors, :_run_initialize_callbacks, :table_name_prefix?, :logger, :table_name_suffix?, :type_for_attribute, :model_name, :pluralize_table_names?, :__callbacks?, :store_full_sti_class, :_run_find_callbacks, :store_full_sti_class?, :default_scope_override, :reload, :changed_for_autosave?, :attachment_changes, :validates_attachment_presence, :validates_attachment_size, :validates_attachment_content_type, :validates_media_type_spoof_detection, :validates_attachment_file_name, :do_not_validate_attachment_file_type, :run_paperclip_callbacks, :to_sgid, :to_sgid_param, :to_global_id, :to_gid, :to_gid_param, :to_signed_global_id, :generate_permalink, :save_permalink, :friendly_id?, :unfriendly_id?, :save, :save!, :serializable_hash, :as_json, :from_json, :read_attribute_for_serialization, :touch, :no_touching?, :touch_later, :committed!, :rolledback!, :trigger_transactional_callbacks?, :with_transaction_returning_status, :transaction, :before_committed!, :destroy, :_destroy, :mark_for_destruction, :destroyed_by_association=, :marked_for_destruction?, :destroyed_by_association, :association, :association_cached?, :increment!, :saved_change_to_attribute?, :attribute_before_last_save, :changed_attribute_names_to_save, :has_changes_to_save?, :saved_change_to_attribute, :attribute_in_database, :saved_changes?, :saved_changes, :will_save_change_to_attribute?, :attribute_change_to_be_saved, :changes_to_save, :attributes_in_database, :changes_applied, :changed?, :attribute_changed?, :attribute_previously_changed?, :restore_attributes, :clear_changes_information, :changed, :changed_attributes, :previous_changes, :attribute_changed_in_place?, :attribute_was, :changes, :clear_attribute_changes, :id=, :id, :id?, :id_before_type_cast, :to_key, :id_was, :id_in_database, :query_attribute, :read_attribute_before_type_cast, :attributes_before_type_cast, :write_attribute, :_write_attribute, :read_attribute, :_read_attribute, :attributes, :has_attribute?, :attribute_for_inspect, :[], :[]=, :attribute_present?, :accessed_fields, :respond_to?, :attribute_names, :method_missing, :attribute_missing, :respond_to_without_attributes?, :with_lock, :lock!, :locking_enabled?, :valid?, :validate, :validates_numericality_of, :validates_absence_of, :validates_inclusion_of, :validates_format_of, :validates_exclusion_of, :validates_acceptance_of, :validates_confirmation_of, :validates_presence_of, :validates_length_of, :validates_size_of, :run_callbacks, :validates_with, :invalid?, :validate!, :errors, :read_attribute_for_validation, :cache_key, :cache_key_with_version, :to_param, :cache_version, :to_partial_path, :to_model, :assign_attributes, :attributes=, :populate_with_current_scope_attributes, :initialize_internals_callback, :increment, :decrement, :destroy!, :delete, :becomes, :becomes!, :update_attribute, :update_column, :decrement!, :toggle, :update_columns, :toggle!, :update, :update_attributes, :update_attributes!, :update!, :persisted?, :destroyed?, :new_record?, :==, :pretty_print, :slice, :readonly?, :readonly!, :eql?, :present?, :connection_handler, :blank?, :init_with_attributes, :encode_with, :freeze, :inspect, :hash, :init_with, :frozen?, :require_dependency, :to_json, :__binding__, :instance_values, :instance_variable_names, :presence_in, :in?, :presence, :pry, :deep_dup, :with_options, :acts_like?, :duplicable?, :to_yaml, :to_query, :html_safe?, :pretty_print_instance_variables, :pretty_print_inspect, :pretty_print_cycle, :try!, :try, :require_or_load, :load_dependency, :unloadable, :instance_variable_defined?, :remove_instance_variable, :instance_of?, :kind_of?, :is_a?, :tap, :instance_variable_set, :protected_methods, :instance_variables, :instance_variable_get, :public_methods, :private_methods, :method, :public_method, :public_send, :singleton_method, :class_eval, :define_singleton_method, :remote_byebug, :byebug, :debugger, :extend, :to_enum, :enum_for, :===, :zeitwerk_original_require, :=~, :!~, :pretty_inspect, :gem, :object_id, :send, :to_s, :display, :nil?, :class, :singleton_class, :clone, :dup, :itself, :yield_self, :then, :taint, :tainted?, :untaint, :untrust, :untrusted?, :trust, :methods, :singleton_methods, :equal?, :!, :instance_exec, :!=, :instance_eval, :__id__, :__send__]
