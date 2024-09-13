package org.springframework.samples.petclinic.chat.tools;

import com.fasterxml.jackson.annotation.JsonClassDescription;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonPropertyDescription;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Description;
import org.springframework.samples.petclinic.chat.service.OwnerService;
import org.springframework.samples.petclinic.chat.dto.Owner;

import java.util.List;
import java.util.function.Function;

@Configuration
public class OwnerTools {

    private final OwnerService ownerService;

    @Autowired
    public OwnerTools(OwnerService ownerService) {
        this.ownerService = ownerService;
    }

    @Bean
    @Description("Query the owners by last name, the owner information include owner id, address, telephone, city, first name and last name" + "\n The owner also include the pets information, include the pet name, pet type and birth" + "\n The pet include serveral visit record, include the visit name and visit date")
    public Function<OwnerQueryRequest, List<Owner>> queryOwners() {
        return name -> ownerService.queryOwners(name.firstName);
    }

    @Bean
    @Description("Create a new owner by providing the owner's firstName, lastName, address, telephone and city")
    public Function<OwnerCURequest, Owner> addOwner() {
        return request -> {
            Owner owner = new Owner();
            owner.setAddress(request.address);
            owner.setTelephone(request.telephone);
            owner.setCity(request.city);
            owner.setLastName(request.lastName);
            owner.setFirstName(request.firstName);
            this.ownerService.save(owner);
            return owner;
        };
    }

    @Bean
    @Description("update a owner's firstName, lastName, address, telephone and city by providing the owner id\"")
    public Function<OwnerCURequest, Owner> updateOwner() {
        return request -> {
            Owner owner = ownerService.findById(Integer.parseInt(request.ownerId));
            if (request.address != null) {
                owner.setAddress(request.address);
            }
            if (request.telephone != null) {
                owner.setTelephone(request.telephone);
            }
            if (request.city != null) {
                owner.setCity(request.city);
            }
            if (request.lastName != null) {
                owner.setLastName(request.lastName);
            }
            if (request.firstName != null) {
                owner.setFirstName(request.firstName);
            }
            this.ownerService.save(owner);
            return owner;
        };
    }


    @JsonInclude(JsonInclude.Include.NON_NULL)
    @JsonClassDescription("Owner Query Request")
    public record OwnerQueryRequest(
        @JsonProperty(required = false, value = "firstName") @JsonPropertyDescription("The Owner first name") String firstName) {
    }

    @JsonInclude(JsonInclude.Include.NON_NULL)
    @JsonClassDescription("Owner Create or Update Request. If ownerId is provided, it will be treated as update, otherwise create.")
    public record OwnerCURequest(
        @JsonProperty(required = false, value = "ownerId") @JsonPropertyDescription("The Owner Id") String ownerId,
        @JsonProperty(required = true, value = "lastName") @JsonPropertyDescription("The Owner last name") String lastName,
        @JsonProperty(required = true, value = "firstName") @JsonPropertyDescription("The Owner First name") String firstName,
        @JsonProperty(required = true, value = "address") @JsonPropertyDescription("The Owner address") String address,
        @JsonProperty(required = true, value = "telephone") @JsonPropertyDescription("The Owner telephone") String telephone,
        @JsonProperty(required = true, value = "city") @JsonPropertyDescription("The Owner city") String city) {
    }

}
